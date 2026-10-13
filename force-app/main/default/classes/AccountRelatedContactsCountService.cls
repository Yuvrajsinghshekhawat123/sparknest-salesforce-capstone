public with sharing class AccountRelatedContactsCountService {
    public AccountRelatedContactsCountService() {

    }

   @future
   public static void countRelatedContacts(Set<Id> accountIds) { 


        System.debug('===== FUTURE METHOD STARTED =====');
        System.debug('Account IDs: ' + accountIds);


        Map<Id, Integer> contactCounts = new Map<Id, Integer>();

        // initialize every Account with 0
        for (Id accountId : accountIds) {
            contactCounts.put(accountId, 0);
        }
        

        for(Contact con: [select AccountId from Contact where AccountId IN :accountIds]){
            contactCounts.put(con.AccountId, contactCounts.get(con.AccountId) + 1);
        }


        List<Account> updatedAccounts=new List<Account>();
        for(Id accId : contactCounts.keySet()){
            Account acc=new Account();
            acc.Id=accId;
            acc.Total_Contacts__c=contactCounts.get(accId);

            updatedAccounts.add(acc);
        }


        if(!updatedAccounts.isEmpty()){
            update updatedAccounts;
        }

        System.debug('===== FUTURE METHOD COMPLETED =====');


   }
         
}