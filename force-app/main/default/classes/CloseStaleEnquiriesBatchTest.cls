@isTest
public class CloseStaleEnquiriesBatchTest {
    
    @isTest
    static void testBatch() {
        Enquiry__c e = TestDataFactory.createEnquiryWithBudget(5000, true);
        e.Status__c = 'In Progress';
        update e;

        // Delete tasks auto-created by triggers so the enquiry is considered stale
        delete [SELECT Id FROM Task WHERE WhatId = :e.Id];

        Test.startTest();
        new CloseStaleEnquiriesBatch().execute(
            null,
            new List<Enquiry__c>{ e }
        );
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