@IsTest
public with sharing class TestDataFactory {
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