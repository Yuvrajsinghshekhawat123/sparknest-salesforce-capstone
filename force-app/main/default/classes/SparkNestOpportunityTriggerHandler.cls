public with sharing class SparkNestOpportunityTriggerHandler {
    public SparkNestOpportunityTriggerHandler() {

    }

     public static void handleBeforeUpdate(Map<Id, Opportunity> oldOpportunityMap,Map<Id, Opportunity> newOpportunityMap){
        for (Id opportunityId : newOpportunityMap.keySet()) {
            Opportunity oldOpportunity =
                oldOpportunityMap.get(opportunityId);

            Opportunity newOpportunity =
                newOpportunityMap.get(opportunityId);

            if (oldOpportunity.StageName != newOpportunity.StageName &&
                newOpportunity.StageName == 'Closed Won') {
                
                newOpportunity.CloseDate=Date.today();
                newOpportunity.Type='New Customer';
            }
        } 
    }


    public static void handleAfterInsert(List<Opportunity> Opportunities){
        Set<Id> accountIds=new Set<Id>();

        for(Opportunity oppRecord: Opportunities){
            if (oppRecord.AccountId != null) 
                accountIds.add(oppRecord.AccountId);
        }
        SparkNestOpportunityHandlerService.calculateAndUpdateAccount(accountIds);
    }
    

   public static void handleAfterUpdate(Map<Id, Opportunity> oldMap,
   Map<Id, Opportunity> newMap) {

        Set<Id> accountIds = new Set<Id>();

        for (Id opportunityId : newMap.keySet()) {

            Opportunity oldOpp = oldMap.get(opportunityId);
            Opportunity newOpp = newMap.get(opportunityId);

            if (oldOpp.AccountId != newOpp.AccountId || oldOpp.Amount != newOpp.Amount) {

                if (oldOpp.AccountId != null) {
                    accountIds.add(oldOpp.AccountId);
                }

                if (newOpp.AccountId != null) {
                    accountIds.add(newOpp.AccountId);
                }
            }
        }

        if (!accountIds.isEmpty()) {
            SparkNestOpportunityHandlerService.calculateAndUpdateAccount(accountIds);
        }
    }

    public static void handleAfterDelete(List<Opportunity> Opportunities){
            Set<Id> accountIds = new Set<Id>();

            for (Opportunity oppRecord : opportunities) {
                if (oppRecord.AccountId != null) {
                    accountIds.add(oppRecord.AccountId);
                }
            }

            SparkNestOpportunityHandlerService.calculateAndUpdateAccount(accountIds);

    }





    public static void handleAfterInsert2(List<Opportunity> opportunities){

        List<Opportunity> qualifyingOpportunities = new List<Opportunity>();
        
        for(Opportunity oppRecord:opportunities){
            if(oppRecord.Amount != null &&  oppRecord.Amount > 5000000){
                qualifyingOpportunities.add(oppRecord);
            }
        }

        if(qualifyingOpportunities.isEmpty()) return;

        User salesManager = [
            select Id from User where UserRole.Name='Eastern Sales Manager'
            and IsActive=true limit 1
        ];


        List<OpportunityTeamMember> teamMembers =
        new List<OpportunityTeamMember>();

        for(Opportunity opp: qualifyingOpportunities){
            OpportunityTeamMember teamMember=new OpportunityTeamMember();
            teamMember.OpportunityId = opp.Id;
            teamMember.UserId = salesManager.Id;
            teamMember.TeamMemberRole = 'Eastern Sales Manager';
            teamMembers.add(teamMember);

        }

        // one dml
        if (!teamMembers.isEmpty()) {
            insert teamMembers;
        }
    }



    

    public static void handleAfterUpdate2(Map<Id, Opportunity> oldMap,
    Map<Id, Opportunity> newMap){
        Set<Id> qualifyingOpportunitiesAccountIds=new Set<Id>();
        

        for(Id oppId: newMap.keySet()){
            Opportunity newOppRecord = newMap.get(oppId);
            Opportunity oldOppRecord=oldMap.get(oppId);

            if(newOppRecord.StageName=='Closed Won' && oldOppRecord.StageName!=newOppRecord.StageName){
                qualifyingOpportunitiesAccountIds.add(newOppRecord.AccountId);
            }
        }

        List<Account>accountsToUpdate = new List<Account>();
        for(Account acc: [select Rating from  Account where Id IN :qualifyingOpportunitiesAccountIds]){
            acc.Rating = 'Hot';
            accountsToUpdate.add(acc);
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
    }




    public static void handleAfterUpdate3(Map<Id, Opportunity> oldMap,
    Map<Id, Opportunity> newMap){

         // get related account ids
        Set<Id> relatedAccountIds=new Set<Id>();
        for(Id oppId: newMap.keySet()){
            Opportunity newOpp=newMap.get(oppId);
            Opportunity oldOpp=oldMap.get(oppId);

            if(newOpp.StageName =='Closed Won' &&  oldOpp.StageName != newOpp.StageName){
                 if (newOpp.AccountId != null) {
                    relatedAccountIds.add(newOpp.AccountId);
                }
            }
        }
 

        OpportunityService.updateOpportunityRelatedAccount(relatedAccountIds);
        
    }
    



     

}