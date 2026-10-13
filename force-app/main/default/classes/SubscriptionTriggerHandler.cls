public with sharing class SubscriptionTriggerHandler {

    public static void run(List<Subscription__c> newList, Map<Id, Subscription__c> oldMap) {
        Set<Id> accountIds = new Set<Id>();

        if (newList != null) {
            for (Subscription__c s : newList) {
                Subscription__c old = (oldMap != null) ? oldMap.get(s.Id) : null;
                if (old == null) {
                    if (s.Account__c != null) accountIds.add(s.Account__c);
                } else if (s.Status__c != old.Status__c || s.Account__c != old.Account__c) {
                    if (s.Account__c != null) accountIds.add(s.Account__c);
                    if (old.Account__c != null) accountIds.add(old.Account__c);
                }
            }
        } else if (oldMap != null) {
            for (Subscription__c old : oldMap.values()) {
                if (old.Account__c != null) accountIds.add(old.Account__c);
            }
        }

        if (!accountIds.isEmpty()) recalculate(accountIds);
    }

    private static void recalculate(Set<Id> accountIds) {
        Map<Id, Decimal> counts = new Map<Id, Decimal>();
        for (Id accId : accountIds) counts.put(accId, 0);

        for (AggregateResult ar : [
            SELECT Account__c acc, COUNT(Id) cnt
            FROM Subscription__c
            WHERE Account__c IN :accountIds AND Status__c = 'Active'
            GROUP BY Account__c
        ]) {
            counts.put((Id) ar.get('acc'), (Decimal) ar.get('cnt'));
        }

        List<Account> toUpdate = new List<Account>();
        for (Id accId : counts.keySet()) {
            toUpdate.add(new Account(Id = accId, Total_Active_Subscriptions__c = counts.get(accId)));
        }
        update toUpdate;
    }
}