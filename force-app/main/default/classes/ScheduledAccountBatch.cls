global with sharing class ScheduledAccountBatch implements Database.Batchable<SObject>, 
Database.Stateful, Schedulable {


    global Integer totalProcessed = 0;



    // Schedulable 
    global void execute(SchedulableContext sc) {
        // Start the batch
        Database.executeBatch(this, 200);
    }


    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Name, Rating
            FROM Account
            WHERE Rating = 'Cold'
        ]);
    }

    global void execute(Database.BatchableContext context, List<Account> scope) {

        for (Account acc : scope) {
            // Update Account status
            acc.Rating = 'Warm';
        }

        if (!scope.isEmpty()) {
            update scope;

            // Stateful counter
            totalProcessed += scope.size();
        }

    }

    global void finish(Database.BatchableContext context) {
         System.debug(
            'Total Accounts Processed: ' + totalProcessed
        );
    }
}