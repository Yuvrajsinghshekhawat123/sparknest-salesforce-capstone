public without sharing class EnquiryStatusLookupAction {

    public class ActionRequest {
        @InvocableVariable(label='Customer Email' required=true)
        public String customerEmail;
    }

    public class ActionResponse {
        @InvocableVariable(label='Is Contact Found')
        public Boolean isContactFound;

        @InvocableVariable(label='Is Enquiry Found')
        public Boolean isEnquiryFound;

        @InvocableVariable(label='Enquiry Name')
        public String enquiryName;

        @InvocableVariable(label='Status')
        public String status;

        @InvocableVariable(label='Closed Date')
        public Date closedDate;
    }

    @InvocableMethod(
        label='Check Enquiry Status'
        description='Finds a customer enquiry using their email address'
    )
    public static List<ActionResponse> getStatus(List<ActionRequest> requests) {
        List<ActionResponse> results = new List<ActionResponse>();

        if (requests == null || requests.isEmpty()) {
            return results;
        }

        Set<String> emails = new Set<String>();

        // Pre-initialize response list so indices match requests 1:1
        for (ActionRequest req : requests) {
            ActionResponse res = new ActionResponse();
            res.isContactFound = false;
            res.isEnquiryFound = false;
            results.add(res);

            if (req != null && String.isNotBlank(req.customerEmail)) {
                emails.add(req.customerEmail.trim().toLowerCase());
            }
        }

        if (emails.isEmpty()) {
            return results;
        }

        // 1. Find Contacts by email (use lowercase keys for safe map lookups)
        Map<String, Id> contactIdsByEmail = new Map<String, Id>();

        for (Contact con : [
            SELECT Id, Email 
            FROM Contact 
            WHERE Email IN :emails
        ]) {
            if (String.isNotBlank(con.Email)) {
                contactIdsByEmail.put(con.Email.toLowerCase(), con.Id);
            }
        }

        if (contactIdsByEmail.isEmpty()) {
            return results;
        }

         


        // 2. Fetch the most recent Enquiry linked to those Contact IDs
        Map<Id, Enquiry__c> latestEnquiryByContact = new Map<Id, Enquiry__c>();
        List<Enquiry__c> enquires=[SELECT Id, Name, Contact__c, Status__c, Closed_Date__c, CreatedDate
            FROM Enquiry__c
            WHERE Contact__c IN :contactIdsByEmail.values()
        ORDER BY CreatedDate DESC, Id DESC];

        System.debug('eeeeeeeee' + enquires);


        for (Enquiry__c enquiry : enquires) {
            if (!latestEnquiryByContact.containsKey(enquiry.Contact__c)) {
                latestEnquiryByContact.put(enquiry.Contact__c, enquiry);
            }
        }

       System.debug('ddddddddddddddddd' + latestEnquiryByContact);
       System.debug('rrrrrrrr' + requests);
        




        // 3. Match each response back to its request
        for (Integer i = 0; i < requests.size(); i++) {
            ActionRequest req = requests[i];
            ActionResponse res = results[i];

            if (req == null || String.isBlank(req.customerEmail)) {
                continue;
            }

            String searchEmail = req.customerEmail.trim().toLowerCase();
            Id contactId = contactIdsByEmail.get(searchEmail);

            if (contactId == null) {
                continue;
            }

            res.isContactFound = true;

            Enquiry__c enquiry = latestEnquiryByContact.get(contactId);

            if (enquiry != null) {
                res.isEnquiryFound = true;
                res.enquiryName = enquiry.Name;
                res.status = enquiry.Status__c;
                res.closedDate = enquiry.Closed_Date__c;
            }
        }


        System.debug('resssssssssssss'+results);

        return results;
    }
}