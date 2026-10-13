public with sharing class SparkNestAccountPhoneTriggerHandler {
    public SparkNestAccountPhoneTriggerHandler() {

    }

     public static void handleAfterUpdate(Map<Id, Account> oldAccountMap,
     Map<Id, Account> newAccountMap) {
        Set<Id> accountIds = new Set<Id>();

        // find accounts where phone changed
        for (Id accountId : newAccountMap.keySet()) {
            Account oldAccount = oldAccountMap.get(accountId);
            Account newAccount = newAccountMap.get(accountId);
            if (oldAccount.Phone != newAccount.Phone) {
                accountIds.add(accountId);
            }
        }
        // stop if no account phone changed
        if (accountIds.isEmpty()) {
            return;
        }

        List<Contact> contactsToUpdate = new List<Contact>();

        // Get related Contacts
        for (Contact con : [
            select Id, AccountId, HomePhone, OtherPhone
            from Contact
            where AccountId IN :accountIds
        ]) {

            Account oldAccount = oldAccountMap.get(con.AccountId);
            Account newAccount = newAccountMap.get(con.AccountId);

            con.HomePhone = newAccount.Phone;
            con.OtherPhone = oldAccount.Phone;

            contactsToUpdate.add(con);
        }

        // one bulk dml operation
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}