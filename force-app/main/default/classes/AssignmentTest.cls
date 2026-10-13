@IsTest
private class AssignmentTest {

    @TestSetup
    static void setupData() { 
        TestDataFactory.createAccounts(5);
    }



    @IsTest
    static void testAssignment6() {

        List<Account> accounts = [
            SELECT Id, Name, Rating
            FROM Account
        ];

        Set<Id> accountIds = new Set<Id>();

        for(Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        Test.startTest();

        OpportunityService.updateOpportunityRelatedAccount(accountIds);

        Test.stopTest();

        List<Account> updatedAccounts = [
            SELECT Id, Name, Rating
            FROM Account
            WHERE Id IN :accountIds
        ];

        for(Account acc : updatedAccounts) {
            System.assertEquals(
                'Hot',
                acc.Rating,
                'Account Rating should be Hot'
            );
        }
    }





    // @IsTest
    // static void testBatchAccountProcessing() {

    //     ScheduledAccountBatch batch =
    //         new ScheduledAccountBatch();

    //     Test.startTest();

    //     Database.executeBatch(batch, 200);

    //     Test.stopTest();


    //     // Get Accounts after Batch execution
    //     List<Account> accounts = [
    //         SELECT Id, Name, Rating
    //         FROM Account
    //     ];


    //     System.assertEquals(
    //         5,
    //         accounts.size()
    //     );


    //     // Verify Batch updated Accounts
    //     for (Account acc : accounts) {

    //         System.assertEquals(
    //             'Warm',
    //             acc.Rating,
    //             'Account should have been updated to Warm'
    //         );
    //     }
    // }


    // // ==========================================
    // // TEST SCHEDULER
    // // ==========================================
    // @IsTest
    // static void testScheduledAccountProcessing() {

    //     Test.startTest();

    //     String cronExpression = '0 0 1 * * ?';

    //     String jobId = System.schedule(
    //         'Test SparkNest Account Processing',
    //         cronExpression,
    //         new ScheduledAccountBatch()
    //     );

    //     Test.stopTest();


    //     // Verify scheduled job exists
    //     CronTrigger scheduledJob = [
    //         SELECT Id, CronExpression
    //         FROM CronTrigger
    //         WHERE Id = :jobId
    //     ];


    //     System.assertEquals(
    //         cronExpression,
    //         scheduledJob.CronExpression
    //     );
    // }




  
    @IsTest
    static void testAssignment5() {
        // Test assignment 5

    }





  
   





//   @IsTest
//     static void testERPCallout() {
//         // Test assignment 3


//         // Register fake ERP response
//         Test.setMock(HttpCalloutMock.class,new ERPCalloutMock());

//         Test.startTest();

//          // Execute Batch Apex
//         Database.executeBatch(new AccountERPBatch(),5);


//         Test.stopTest();


//         // verfiy test data
//         Integer accountCount=[select COUNT() from Account];

//         System.assertEquals(5, accountCount,'There should be 5 test Accounts');

//     }







    // @IsTest
    // static void testStatefulBatch() {
    //     // Test assignment 2
    //     OpportunityProcessingBatch batch = new OpportunityProcessingBatch();

    //     // Calculate expected result from test data
    //     AggregateResult result = [
    //         SELECT SUM(Amount) totalAmount
    //         FROM Opportunity
    //     ];

    //     Decimal expectedAmount = (Decimal) result.get('totalAmount');

    //     Test.startTest();

    //     Database.executeBatch(batch, 10);

    //     Test.stopTest();

        
    //     System.assertEquals(10,OpportunityProcessingBatch.finalTotalOpportunities);
    //     System.assertEquals(expectedAmount,OpportunityProcessingBatch.finalTotalAmount);
    // }



    
    // @IsTest
    // static void testAccountRatingSchedule() {
    //      // test assignment 1

    //     Test.startTest();

    //     String cron = '0 0 2 * * ?'; // every day at 2 am 

    //     System.schedule( 'Test Account Schedule', cron, new AccountRatingSchedule());
    //     Test.stopTest();

    //     List<Account> accounts = [SELECT Id, Rating FROM Account];

    //     for(Account acc : accounts) {
    //         System.assertEquals('Warm',acc.Rating);
    //     }
    // }





}