public with sharing class SparkNestAccountTriggerHandler {
    public SparkNestAccountTriggerHandler() {

    }

    public static void handleBeforeDelete(List<Account> oldAccounts) {
        Set<Id> accountIds=new Set<Id>();

        // collect account ids
        for(Account acc: oldAccounts){
            accountIds.add(acc.Id);
        }

        // count contacts for each  accounts
        Map<Id, Integer> contactCountByAccount = new Map<Id, Integer>();
        
        for(Contact con:[SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]){
            if(!contactCountByAccount.containsKey(con.AccountId)){
                contactCountByAccount.put(con.AccountId,0);
            }

            contactCountByAccount.put(con.AccountId,contactCountByAccount.get(con.AccountId)+1);
        }


        // prevent deletion if account has 2 or more contacts
        for(Account acc: oldAccounts){
            Integer contactCount=contactCountByAccount.containsKey(acc.Id) ? contactCountByAccount.get(acc.Id) : 0;
            if(contactCount >= 2){
                acc.addError(  'This Account cannot be deleted because it has two or more associated Contacts.');
            } 
        }
    }



    // public static void handleAfterInsert(List<Account> newAccounts) {
    //     Set<Id> accountIds=new Set<Id>();

    //     for(Account acc : newAccounts){
    //         accountIds.add(acc.Id);
    //     }
    //     AccountService.countRelatedContacts(accountIds);
    // }




    public static void handleAfterInsert2(List<Account> newAccounts) {
        Set<Id> accountIds=new Set<Id>();

        for(Account acc : newAccounts){
            accountIds.add(acc.Id);
        }

        System.enqueueJob(
            new AccountContactCountQueueable(accountIds)
        );
    }


    public static void handleAfterUpdate(Map<Id, Contact> oldMap,
    Map<Id, Contact> newMap) {

        Set<Id> accountIds = newMap.keySet();

        for (Id contactId : newMap.keySet()) {
            Contact oldCont = oldMap.get(contactId);
            Contact newCont = newMap.get(contactId);

            if (oldCont.AccountId != newCont.AccountId) {

                if (oldCont.AccountId != null) {
                    accountIds.add(oldCont.AccountId);
                }

                if (newCont.AccountId != null) {
                    accountIds.add(newCont.AccountId);
                }
            }
        }
        if (!accountIds.isEmpty()) {
            System.enqueueJob(
                new AccountContactCountQueueable(accountIds)
            );
    }


}












    
}