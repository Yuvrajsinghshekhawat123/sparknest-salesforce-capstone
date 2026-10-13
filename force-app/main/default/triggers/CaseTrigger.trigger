trigger CaseTrigger on Case (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountDeleteTriggerHandler.handleAfterInsert(Trigger.new);
    }
}