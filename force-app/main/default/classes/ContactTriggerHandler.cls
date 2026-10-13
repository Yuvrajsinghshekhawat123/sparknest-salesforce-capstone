public with sharing class ContactTriggerHandler {

    public static void handleAfterInsert(List<Contact> newContacts) {
        Set<Id> accountIds=new Set<Id>();

        for(Contact contact : newContacts){
            accountIds.add(contact.AccountId);
        }

        System.enqueueJob(new AccountContactCountQueueable(accountIds));
    }


    public static void handleAfterUpdate(Map<Id, Contact> oldMap,
    Map<Id, Contact> newMap) {

        Set<Id> accountIds = new Set<Id>();

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


    public static void handleAfterDelete(List<Contact> oldContacts){
        Set<Id> accountIds = new Set<Id>();

        for(Contact contact: oldContacts){
            if (contact.AccountId != null)
               accountIds.add(contact.AccountId);
        }
        if (!accountIds.isEmpty()) {
            System.enqueueJob(new AccountContactCountQueueable(accountIds));
        }
    }



}