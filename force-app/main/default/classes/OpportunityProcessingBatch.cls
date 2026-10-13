public with sharing class OpportunityProcessingBatch implements 
Database.Batchable<SObject>, Database.Stateful {
    @TestVisible
    Integer totalOpportunities = 0;

    @TestVisible
    Decimal totalAmount = 0; 

    @TestVisible
    static Integer finalTotalOpportunities;

    @TestVisible
    static Decimal finalTotalAmount;

    public Database.QueryLocator start(Database.BatchableContext context) {
         
        return Database.getQueryLocator('select Id, Name,Amount from Opportunity');
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        for(Opportunity opp : scope) {

            totalOpportunities++;

            if(opp.Amount != null) {
                totalAmount += opp.Amount;
            }
        }
    }

    public void finish(Database.BatchableContext context) {

         
        finalTotalOpportunities = totalOpportunities;
        finalTotalAmount = totalAmount;

        System.debug('Total Opportunities Processed: ' + totalOpportunities);
        System.debug('Total Opportunity Amount: ₹' +totalAmount);
    }


}