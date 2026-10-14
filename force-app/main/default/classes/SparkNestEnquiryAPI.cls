@RestResource(urlMapping='/SparkNestEnquiryAPI/*')
global with sharing class SparkNestEnquiryAPI {

    // Wrapper class for incoming JSON request
    global class EnquiryRequest {
        public String firstName;
        public String lastName;
        public String email;
        public String phone;
        public String subject;
    }
    
    // Wrapper class for JSON response
    global class EnquiryResponse {
        public Boolean success;
        public String message;
        public Id contactId;
        public Id enquiryId;

        public EnquiryResponse(Boolean success, String message, Id contactId, Id enquiryId) {
            this.success = success;
            this.message = message;
            this.contactId = contactId;
            this.enquiryId = enquiryId;
        }
    }


    @HttpPost 
    global static EnquiryResponse submitEnquiry(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;


        // prevent NullPointerException if the body is completely empty
        if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
            res.statusCode = 400;
            return new EnquiryResponse(false, 'Request body cannot be empty.', null, null);
        }

        // parse json body
        EnquiryRequest data=(EnquiryRequest) JSON.deserialize(
            req.requestBody.toString(), 
            EnquiryRequest.class
        );


        //Scenario-3---> validation - Missing email
        if(String.isBlank(data.email)){
            res.statuscode=400;
            return new EnquiryResponse(false, 'Email is required.', null, null);
        }


        Id targetContactId;

        // check if contact already exits by eamil
        List<Contact> existingContacts = [
            SELECT Id 
            FROM Contact 
            WHERE Email = :data.email 
            LIMIT 1
        ];

        if(!existingContacts.isEmpty()){
            // Scenario-2 --> Existing customer
            targetContactId = existingContacts[0].Id;
        }else{
            // Scenario 1 ----> New customer - Create Contact
            Contact newContact = new Contact(
                FirstName = data.firstName,
                LastName = String.isNotBlank(data.lastName) ? data.lastName : 'Website Lead',
                Email = data.email,
                Phone = data.phone
            );
            insert newContact;
            targetContactId = newContact.Id;

        }


        // create enquiry record and link to Contact
        Enquiry__c newEnquiry = new Enquiry__c(
            Contact__c = targetContactId,
            Name = String.isNotBlank(data.subject) ? data.subject : 'Website Enquiry',
            Status__c = 'New'
        );
        insert newEnquiry;


        res.statusCode = 200;
        return new EnquiryResponse(
            true, 
            'Enquiry submitted successfully.', 
            targetContactId, 
            newEnquiry.Id
        );
    }
    
}