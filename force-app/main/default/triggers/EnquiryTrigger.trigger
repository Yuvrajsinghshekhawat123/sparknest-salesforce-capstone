trigger EnquiryTrigger on Enquiry__c (before insert, before update, after insert) {

    TriggerDispatcher.dispatch(
        new EnquiryService()
    );

}