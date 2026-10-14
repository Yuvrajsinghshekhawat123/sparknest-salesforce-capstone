@IsTest
public with sharing class TestDataFactory {

    // Creates one Enquiry with valid default values.
    public static Enquiry__c createEnquiry(Boolean insertRecord) {
        Enquiry__c enquiry = new Enquiry__c();
        // Set valid default field values
        enquiry.Name = 'Test Enquiry';
        enquiry.Customer_Budget__c = 5000;
        enquiry.Status__c = 'New';

        // Insert only when requested
        if (insertRecord) {
            insert enquiry;
        }
        return enquiry;
    }

     // Creates an Enquiry with a custom budget.
    public static Enquiry__c createEnquiryWithBudget(Decimal budget, Boolean insertRecord) {
        Enquiry__c enquiry = createEnquiry(false);
        enquiry.Customer_Budget__c = budget;

        if (insertRecord) {
            insert enquiry;
        }
        return enquiry;
    }

    // Creates multiple Enquiries for bulk testing.
    public static List<Enquiry__c> createEnquiries(Integer recordCount) {
        List<Enquiry__c> enquiries = new List<Enquiry__c>();

        for (Integer i = 0; i < recordCount; i++) {
            Enquiry__c enquiry = new Enquiry__c();

            enquiry.Name = 'Test Enquiry ' + i;
            enquiry.Customer_Budget__c = 5000;
            enquiry.Status__c = 'New';
            enquiry.OwnerId = UserInfo.getUserId();

            enquiries.add(enquiry);
        }
        return enquiries;
    }


    






























    public static List<Account> createAccounts(Integer count){
        List<Account> accounts=new List<Account>();

        for(Integer i = 1; i <= count; i++) {

            Account acc = new Account(
                Name = 'Test Account ' + i,
                Rating = 'Cold',
                Industry = 'Technology'
            );

            accounts.add(acc);
        }

        insert accounts;

        return accounts;
    }

    public static List<Opportunity> createOpportunities(Integer count,Id accountId) {

        List<Opportunity> opportunities = new List<Opportunity>();

        for(Integer i = 1; i <= count; i++) {
            Opportunity opp = new Opportunity(
                Name = 'Test Opportunity ' + i,
                AccountId = accountId,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 10000 * i
            );

            opportunities.add(opp);
        }

        insert opportunities;

        return opportunities;
    }
}