public with sharing class SparkNestOpportunityHandlerService {
    public SparkNestOpportunityHandlerService() {

    }

    public static void calculateAndUpdateAccount(Set<Id> accountIds){

        // account id , total opp, total oppp amount;
        Map<Id, Integer> opportunityCountByAccount = new Map<Id, Integer>();
        Map<Id, Decimal> opportunityAmountByAccount = new Map<Id, Decimal>();

        for(Opportunity opp: [select name, AccountId, Amount from Opportunity where AccountId in :accountIds]){

            if(!opportunityCountByAccount.containsKey(opp.AccountId)){
                opportunityCountByAccount.put(opp.AccountId, 0);
            }
            if(!opportunityAmountByAccount.containsKey(opp.AccountId)){
                opportunityAmountByAccount.put(opp.AccountId, 0);
            }

            Integer opp_count=opportunityCountByAccount.get(opp.AccountId)+1;
            Decimal opp_amount=opportunityAmountByAccount.get(opp.AccountId) + (opp.Amount == null ? 0 : opp.Amount);
             opportunityCountByAccount.put(opp.AccountId, opp_count);
             opportunityAmountByAccount.put(opp.AccountId, opp_amount);

        }

        List<Account> accountsToUpdate = new List<Account>();
        // update the account
        for(Account acc: [select Id, Name,Total_Opportunity_Amount_c__c,Total_Opportunity_Count_c__c from Account where Id in: accountIds]){

            acc.Total_Opportunity_Count_c__c = opportunityCountByAccount.containsKey(acc.Id)? opportunityCountByAccount.get(acc.Id): 0;
            acc.Total_Opportunity_Amount_c__c = opportunityAmountByAccount.containsKey(acc.Id)? opportunityAmountByAccount.get(acc.Id): 0;
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }

    }
}