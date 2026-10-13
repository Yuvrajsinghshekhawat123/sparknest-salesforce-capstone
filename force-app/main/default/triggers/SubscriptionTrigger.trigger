trigger SubscriptionTrigger on Subscription__c (after insert, after update, after delete, after undelete) {
    SubscriptionTriggerHandler.run(Trigger.new, Trigger.oldMap);
}