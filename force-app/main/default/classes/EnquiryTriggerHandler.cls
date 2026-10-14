public interface EnquiryTriggerHandler {
    void beforeInsert(List<Enquiry__c> newRecords);
    void afterInsert(List<Enquiry__c> newRecords);
    void beforeUpdate(List<Enquiry__c> newRecords,Map<Id, Enquiry__c> oldMap);
}