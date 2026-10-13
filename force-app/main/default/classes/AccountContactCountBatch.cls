public with sharing class AccountContactCountBatch  implements Database.Batchable<SObject>{

    public Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('select Id, Name from Account');
    }

    public void execute(Database.BatchableContext context,List<Account> accounts) {
        Set<Id> accountIds = new Set<Id>();

        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        Map<Id, Integer> contactCountByAccount = new Map<Id, Integer>();

        for (Contact con : contacts) {
            if (!contactCountByAccount.containsKey(con.AccountId))
                contactCountByAccount.put(con.AccountId, 0);
            contactCountByAccount.put(con.AccountId,contactCountByAccount.get(con.AccountId) + 1);
        }
        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : accounts) {
            Integer contactCount = contactCountByAccount.containsKey(acc.Id)
                ? contactCountByAccount.get(acc.Id)
                : 0;

            acc.Total_Contacts__c = contactCount;
            accountsToUpdate.add(acc);
        }

        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext context){
        System.debug('Account Contact Count Batch completed.');
    }





}