public with sharing class AccountDeleteTriggerHandler {
    // public static void handleBeforeDelete(List<Account> accounts){

    //     for(Account acc: accounts){
    //         if(acc.Type == 'Customer - Direct'){
    //             acc.addError('You can not delete Account as the type is customer');
    //         }
    //     }
    // }


    public static void handleAfterInsert(List<Case> cases){
        Set<Id> accountIds=new Set<Id>();

        for(Case c: cases){
            if(c.AccountId != null &&  c.Priority== 'High'){
                accountIds.add(c.AccountId);
            }
        }

        if(accountIds.isEmpty()) return;

        List<Account> accounts=[SELECT Id, Name,Rating
        FROM Account
        WHERE Id IN :accountIds
        ];

        for(Account acc: accounts){
            acc.Rating='Hot';
        }

        if(!accounts.isEmpty()){
            update accounts;
        }
    }
}