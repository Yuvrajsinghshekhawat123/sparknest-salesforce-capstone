public with sharing class SparkNestLeadTriggerHandler {
    public SparkNestLeadTriggerHandler() {

    }

    public static void handleBeforeInsert(List<Lead> newLeads){
        // find sales user once
        User salesUser=[select Id from User where Profile.Name='Custom: Sales Profile' and IsActive=true LIMIT 1];
        for(Lead lead: newLeads){
            if(lead.LeadSource=='Web'){
                lead.OwnerId=salesUser.Id;
            }

        }
    }

     
}