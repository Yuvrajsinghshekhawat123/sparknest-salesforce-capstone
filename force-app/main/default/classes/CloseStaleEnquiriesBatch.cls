public class CloseStaleEnquiriesBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime oldDate = System.now().addDays(-30);

        return Database.getQueryLocator([
            SELECT Id, Status__c
            FROM Enquiry__c
            WHERE Status__c = 'In Progress'
            AND LastModifiedDate < :oldDate
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Enquiry__c> records) {
        Set<Id> enquiryIds = new Set<Id>();

        for (Enquiry__c e : records) {
            enquiryIds.add(e.Id);
        }


        // get all enuiry ids who has Task in last 30 days
        Set<Id> enquiryIdsWithActivity = new Set<Id>();
        for (Task t : [
            SELECT WhatId
            FROM Task
            WHERE WhatId IN :enquiryIds
            AND ActivityDate >= :Date.today().addDays(-30)
        ]) {

            enquiryIdsWithActivity.add(t.WhatId);
        }


        // get all enuiry ids who has events in last 30 days
        for (Event e : [
            SELECT WhatId
            FROM Event
            WHERE WhatId IN :enquiryIds
            AND ActivityDate >= :Date.today().addDays(-30)
        ]) {
            enquiryIdsWithActivity.add(e.WhatId);
        }

        for (Enquiry__c e : records) {
            if (!enquiryIdsWithActivity.contains(e.Id)) {
                e.Status__c = 'Closed';
            }
        }


        System.debug('Enquiries with activity: ' + enquiryIdsWithActivity);
        
        update records;
    }

    public void finish(Database.BatchableContext bc) {
    }
}