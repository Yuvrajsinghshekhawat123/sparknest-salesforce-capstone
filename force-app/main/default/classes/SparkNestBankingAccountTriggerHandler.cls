public with sharing class SparkNestBankingAccountTriggerHandler {
    public SparkNestBankingAccountTriggerHandler() {

    }

    public static void handleAfterInsert(List<Account> accounts){
        List<Contact> newContacts=new List<Contact>();

        for(Account acc: accounts){
            if(acc.Industry=='Banking'){
                Contact contact=new Contact();
                contact.LastName=acc.Name;
                contact.Phone=acc.Phone;
                contact.AccountId=acc.Id;

                newContacts.add(contact);
            }
        }

        if(!newContacts.isEmpty()){
            insert newContacts;
        }
    }


}