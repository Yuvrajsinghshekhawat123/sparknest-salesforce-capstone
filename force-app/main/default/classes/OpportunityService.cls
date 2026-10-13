public with sharing class OpportunityService {
    public OpportunityService() {

    }

    // @future
    public static void updateOpportunityRelatedAccount(Set<Id> accountIds){
        List<Account> updatedAccounts=new List<Account>();

        for(Account account: [select Id from account where Id in: accountIds]){
            
            Account acc=new Account();
            acc.Id=account.Id;
            acc.Rating='Hot';

            updatedAccounts.add(acc);
            
        }

        if (!updatedAccounts.isEmpty()) {
            update updatedAccounts;
        }

    }

}