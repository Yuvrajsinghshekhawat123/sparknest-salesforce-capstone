public with sharing class EnquiryProductCountService {
    public static void calculateAndUpdateEnquiry(Set<Id> enquiryIds) {

        List<Enquiry_Product__c> enquiryProducts = [SELECT Id, Enquiry__c FROM Enquiry_Product__c WHERE Enquiry__c IN :enquiryIds];
        Map<Id, Integer> enquiryProductCount = new Map<Id, Integer>();

        for(Enquiry_Product__c ep : enquiryProducts){
            
            if(!enquiryProductCount.containsKey(ep.Enquiry__c)){
                enquiryProductCount.put(ep.Enquiry__c, 0);
            }
            enquiryProductCount.put(ep.Enquiry__c, enquiryProductCount.get(ep.Enquiry__c) + 1);

        }

        List<Enquiry__c> enquiriesToUpdate = [SELECT Id, Total_Products_Interested__c FROM Enquiry__c WHERE Id IN :enquiryIds];
        for(Enquiry__c enquiry : enquiriesToUpdate){
            Integer count = enquiryProductCount.containsKey(enquiry.Id) ? enquiryProductCount.get(enquiry .Id) : 0;
            enquiry.Total_Products_Interested__c = count;
        
        }


        if(!enquiriesToUpdate.isEmpty()){
            update enquiriesToUpdate;
        }
    


            

    }
}