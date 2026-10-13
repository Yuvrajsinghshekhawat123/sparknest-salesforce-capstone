public with sharing class AccountRatingSchedule implements Schedulable {
     
    public void execute(SchedulableContext context) {
        List<Account> accounts= [select id,Rating from Account where Rating='Cold'];


        for(Account acc: accounts){
            acc.Rating='Warm';
        }

        if(!accounts.isEmpty()){
            update accounts;
        }
    }
        


}