trigger EnquiryProductCountTrigger on Enquiry_Product__c (after insert, after update, after delete, after undelete) {

    if (Trigger.isAfter && Trigger.isInsert){

        EnquiryProductCountTriggerHandler.handleAfterInsert(Trigger.new);
    
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        EnquiryProductCountTriggerHandler.handleAfterUpdate(Trigger.oldMap, Trigger.newMap);

    } else if (Trigger.isAfter && Trigger.isDelete) {

        EnquiryProductCountTriggerHandler.handleAfterDelete(Trigger.old);

    } else if (Trigger.isAfter && Trigger.isUndelete) {
        EnquiryProductCountTriggerHandler.handleAfterUndelete(Trigger.new);
    }




}