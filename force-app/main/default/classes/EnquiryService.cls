public class EnquiryService implements EnquiryTriggerHandler {
    // Before Insert
    public void beforeInsert(List<Enquiry__c> newRecords) {
        for (Enquiry__c enquiry : newRecords) {
            // set default Status
            if (String.isBlank(enquiry.Status__c)) {
                enquiry.Status__c = 'New';
            }
            // validate Customer Budget
            if (enquiry.Customer_Budget__c != null && enquiry.Customer_Budget__c < 1000) {
                enquiry.Customer_Budget__c.addError('Customer budget must be at least ₹1,000');
            }
        }
    }

    // After Insert
    public void afterInsert(List<Enquiry__c> newRecords) {
        List<Task> tasksToInsert = new List<Task>();
        for (Enquiry__c enquiry : newRecords) {
            Task followUp = new Task();
            followUp.Subject = 'Follow up: ' + enquiry.Name;
            followUp.ActivityDate = Date.today().addDays(3);
            followUp.OwnerId = enquiry.OwnerId;
            followUp.WhatId = enquiry.Id;

            tasksToInsert.add(followUp);
        }
        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }

    // Before Update
    public void beforeUpdate(List<Enquiry__c> newRecords,Map<Id, Enquiry__c> oldMap) {
        for (Enquiry__c enquiry : newRecords) {
            Enquiry__c oldEnquiry = oldMap.get(enquiry.Id);

            if (enquiry.Status__c == 'Closed' && oldEnquiry.Status__c != 'Closed') {
                enquiry.Closed_Date__c = Date.today();
            }
        }
    }
}