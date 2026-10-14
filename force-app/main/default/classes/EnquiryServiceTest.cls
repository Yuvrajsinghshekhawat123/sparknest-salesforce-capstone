@IsTest
private class EnquiryServiceTest {

    // test 1: Blank Status defaults to new
    @IsTest
    static void testBlankStatusDefaultsToNew() {

        Enquiry__c enquiry = TestDataFactory.createEnquiry(false);
        enquiry.Status__c = null;

        Test.startTest();
        insert enquiry;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Id, Name, Status__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals(
            'New',
            savedEnquiry.Status__c,
            'Blank Status should default to New.'
        );
    }


    // test-2: budget below 1000 is rejected
    @IsTest
    static void testBudgetBelowMinimumFails() {

        Enquiry__c enquiry =
            TestDataFactory.createEnquiryWithBudget(500, false);

        Test.startTest();
        Database.SaveResult result = Database.insert(enquiry, false);
        Test.stopTest();

        System.assertEquals(
            false,
            result.isSuccess(),
            'An Enquiry with budget below 1000 should fail.'
        );

        System.assert(
            result.getErrors().size() > 0,
            'The insert should return a validation error.'
        );
        System.assertEquals( 'Customer budget must be at least ₹1,000',
         result.getErrors()[0].getMessage(),
            'The error message should match EnquiryService.'
        );
    }


    // test-3: Follow-up Task has correct Subject, owner and due date
    @IsTest
    static void testFollowUpTaskCreatedCorrectly() {

        Enquiry__c enquiry = TestDataFactory.createEnquiry(false);

        Test.startTest();
        insert enquiry;
        Test.stopTest();

        List<Task> tasks = [
            SELECT Id, Subject, OwnerId, WhatId, ActivityDate
            FROM Task
            WHERE WhatId = :enquiry.Id
        ];

        System.assertEquals(1, tasks.size(),
            'Exactly one follow-up Task should be created.'
        );

        Task followUp = tasks[0];
        Enquiry__c savedEnquiry = [
            SELECT Id, Name, OwnerId
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals('Follow up: ' + savedEnquiry.Name, followUp.Subject,
            'Task Subject should use the Enquiry Name.'
        );

        System.assertEquals(savedEnquiry.OwnerId, followUp.OwnerId,
            'Task owner should match the Enquiry owner.'
        );

        System.assertEquals( savedEnquiry.Id, followUp.WhatId,
            'Task should be related to the Enquiry.'
        );

        System.assertEquals( Date.today().addDays(3), followUp.ActivityDate,
            'Task due date should be three days from today.'
        );
    }


    // test-4: updating Status to Closed stamps Closed Date
    @IsTest
    static void testClosedDateStamped() {

        Enquiry__c enquiry = TestDataFactory.createEnquiry(true);

        System.assertEquals('New',  enquiry.Status__c,
            'Factory should create an Enquiry with New status.'
        );

        enquiry.Status__c = 'Closed';

        Test.startTest();
        update enquiry;
        Test.stopTest();

        Enquiry__c savedEnquiry = [
            SELECT Id, Status__c, Closed_Date__c
            FROM Enquiry__c
            WHERE Id = :enquiry.Id
        ];

        System.assertEquals('Closed', savedEnquiry.Status__c,
            'Enquiry Status should be Closed.'
        );

        System.assertNotEquals(null, savedEnquiry.Closed_Date__c,
            'Closed Date should be populated.'
        );

        System.assertEquals(Date.today(), savedEnquiry.Closed_Date__c,
            'Closed Date should equal today.'
        );
    }


    // test 5: Bulk insert of 200 Enquiries
    @IsTest
    static void testBulkInsert200Enquiries() {

        List<Enquiry__c> enquiries = TestDataFactory.createEnquiries(200);

        Test.startTest();
        insert enquiries;
        Test.stopTest();

        Set<Id> enquiryIds = new Set<Id>();

        for (Enquiry__c enquiry : enquiries) {
            System.assertNotEquals(null, enquiry.Id,
                'Every inserted Enquiry should have an Id.'
            );

            enquiryIds.add(enquiry.Id);
        }

        List<Enquiry__c> savedEnquiries = [
            SELECT Id, Status__c, Customer_Budget__c
            FROM Enquiry__c
            WHERE Id IN :enquiryIds
        ];

        System.assertEquals(200, savedEnquiries.size(),
            'All 200 Enquiries should be saved.'
        );

        for (Enquiry__c saved : savedEnquiries) {
            System.assertEquals('New', saved.Status__c,
                'Every Enquiry should have New status.'
            );

            System.assertEquals(Decimal.valueOf('5000'), saved.Customer_Budget__c,
                'Every Enquiry should have a valid budget.'
            );
        }

        List<Task> followUpTasks = [
            SELECT Id, Subject, OwnerId, WhatId, ActivityDate
            FROM Task
            WHERE WhatId IN :enquiryIds
        ];

        System.assertEquals(200, followUpTasks.size(),
            'Each Enquiry should create one follow-up Task.'
        );
    }




    @isTest
    static void testBatch() {

        Enquiry__c e = TestDataFactory.createEnquiryWithBudget(5000,true);
        e.Status__c = 'In Progress';


        Test.startTest();
        Database.executeBatch(new CloseStaleEnquiriesBatch(), 200);
        Test.stopTest();

        e = [SELECT Status__c FROM Enquiry__c WHERE Id = :e.Id];

        System.assertEquals('Closed', e.Status__c);
    }



    @isTest
    static void testScheduler() {

        Test.startTest();

        System.schedule(
            'Test Close Stale Enquiries',
            '0 0 1 * * ?',
            new CloseStaleEnquiriesScheduler()
        );

        Test.stopTest();

        System.assertEquals(
            1,
            [SELECT COUNT() FROM CronTrigger
             WHERE CronJobDetail.Name = 'Test Close Stale Enquiries']
        );
    }



}