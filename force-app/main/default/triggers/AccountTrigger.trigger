trigger AccountTrigger on Account (before delete) {

    if(Trigger.isBefore && Trigger.isDelete){
        AccountDeleteTriggerHandler.handleBeforeDelete(Trigger.old);
    }

}