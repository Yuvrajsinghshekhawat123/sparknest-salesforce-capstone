trigger SparkNestAccountPhoneTrigger on Account (after update) {
    SparkNestAccountPhoneTriggerHandler.handleAfterUpdate(Trigger.oldMap,
    Trigger.newMap);
}