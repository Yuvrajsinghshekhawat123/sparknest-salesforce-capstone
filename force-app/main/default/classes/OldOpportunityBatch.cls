public class OldOpportunityBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, StageName, CloseDate
            FROM Opportunity
            WHERE IsClosed = false
            AND CloseDate < :Date.today().addDays(-90)
            ]);
    }


    public void execute(Database.BatchableContext bc,List<Opportunity> scope) {

        for (Opportunity opp : scope) {

            opp.StageName = 'Closed Lost';
            opp.Auto_Close__c = true;
        }

        System.debug('=============='+scope+'=============');

        update scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('===== Old Opportunity Batch Completed =====');
    }
}