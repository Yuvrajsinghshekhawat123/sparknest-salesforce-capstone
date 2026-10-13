trigger SparkNestLeadTrigger on Lead (before insert) {
    SparkNestLeadTriggerHandler.handleBeforeInsert(Trigger.new);
     
}