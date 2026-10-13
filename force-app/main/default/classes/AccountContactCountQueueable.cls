public with sharing class AccountContactCountQueueable implements Queueable {
    private Set<Id> accountIds;
    public AccountContactCountQueueable(Set<Id> accountIds) {
        this.accountIds=accountIds;
    }

    public void execute(QueueableContext context) {

        System.debug('========= Queueable EXECUTED ===========');
        System.debug('Account IDs: ' + accountIds);

        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds
        ];

        Map<Id, Integer> contactCountByAccount = new Map<Id, Integer>();
        for (Contact con : contacts) {

            if (!contactCountByAccount.containsKey(con.AccountId))
                contactCountByAccount.put(con.AccountId, 0);
            
            contactCountByAccount.put(
                con.AccountId,
                contactCountByAccount.get(con.AccountId) + 1
            );
        }

        // now get the accounts that need updating:
        List<Account> accountsToUpdate = [
            SELECT Id, Total_Contacts__c
            FROM Account
            WHERE Id IN :accountIds
        ];

        for (Account acc : accountsToUpdate) {
            Integer count = contactCountByAccount.containsKey(acc.Id)
                ? contactCountByAccount.get(acc.Id)
                : 0;

            acc.Total_Contacts__c = count;
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

}