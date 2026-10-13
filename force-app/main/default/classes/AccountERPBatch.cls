public with sharing class AccountERPBatch implements 
Database.Batchable<SObject>, Database.AllowsCallouts
 {

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('select Id, Name, Phone,  Industry FROM Account');
    }

    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Map<String,Object>> customers = new List<Map<String,Object>>();

        for(Account acc: scope){
            Map<String,Object> customer = new Map<String,Object>();
            customer.put('salesforceId', acc.Id);
            customer.put('name', acc.Name);
            customer.put('phone', acc.Phone);
            customer.put('industry', acc.Industry);

            customers.add(customer);
        }


        // convert it into json 
        String jsonBody= JSON.serialize(customers);

        HttpRequest request= new HttpRequest();
        request.setEndpoint('https://example.com/erp/customers');       // we will use HttpCalloutMock druing testing
        request.setMethod('POST');
        request.setHeader( 
            'Content-Type',
            'application/json'
        );

        request.setBody(jsonBody);



        // send the request;
        Http http =new Http();
        HttpResponse response= http.send(request);


        // handle response
        if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            System.debug('ERP Sync Success: ' + response.getBody());
        }else{
            System.debug('ERP Sync Failed. Status Code: ' + response.getStatusCode());
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('Account ERP synchronization completed.');
    }
}