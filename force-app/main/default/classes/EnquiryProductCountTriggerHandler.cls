public with sharing class EnquiryProductCountTriggerHandler {
     
    public static void handleAfterInsert(List<Enquiry_Product__c> enquiryProducts){
        Set<Id> enquiryIds = new Set<Id>();

        for(Enquiry_Product__c ep : enquiryProducts){
            if(ep.Enquiry__c != null) enquiryIds.add(ep.Enquiry__c);
        }

        if(!enquiryIds.isEmpty()){
            EnquiryProductCountService.calculateAndUpdateEnquiry(enquiryIds);
        }

    }

    public static void handleAfterUpdate(Map<Id,Enquiry_Product__c> oldMap, Map<Id,Enquiry_Product__c> newMap){

        Set<Id> enquiryIds = new Set<Id>();

        for(Id id : newMap.keySet()){
            Enquiry_Product__c oldEp = oldMap.get(id);
            Enquiry_Product__c newEp = newMap.get(id);

            // if Enquiry is update form one Enquiry_Product to another Enquiry_Product
            if(oldEp.Enquiry__c != null && newEp.Enquiry__c != null &&  oldEp.Enquiry__c != newEp.Enquiry__c) {
                enquiryIds.add(oldEp.Enquiry__c);
                enquiryIds.add(newEp.Enquiry__c);
            }

            // if Enquiry  is null and after update if have Enquiry
            else if(oldEp.Enquiry__c == null && newEp.Enquiry__c != null){
                enquiryIds.add(newEp.Enquiry__c);
            }

            // if Enquiry  is not null and after update if have null
            else if(oldEp.Enquiry__c != null && newEp.Enquiry__c == null){
                enquiryIds.add(oldEp.Enquiry__c);
            }
        }

        if(!enquiryIds.isEmpty()){
            EnquiryProductCountService.calculateAndUpdateEnquiry(enquiryIds);
        }
    }


    

    public static void handleAfterDelete(List<Enquiry_Product__c> enquiryProducts){

        Set<Id> enquiryIds = new Set<Id>();
        for(Enquiry_Product__c ep : enquiryProducts){
            if(ep.Enquiry__c != null) enquiryIds.add(ep.Enquiry__c);
        }

        if(!enquiryIds.isEmpty()){
            EnquiryProductCountService.calculateAndUpdateEnquiry(enquiryIds);
        }

    }

    public static void handleAfterUndelete(List<Enquiry_Product__c> enquiryProducts){
        Set<Id> enquiryIds = new Set<Id>();

        for(Enquiry_Product__c ep : enquiryProducts){
            if(ep.Enquiry__c != null) enquiryIds.add(ep.Enquiry__c);
        }

        if(!enquiryIds.isEmpty()){
            EnquiryProductCountService.calculateAndUpdateEnquiry(enquiryIds);
        }
    }
}