public with sharing class CaseMilestoneBreachAction {
    public class Request {
        @InvocableVariable(required=true)
        public Id caseId;
    }

    @InvocableMethod(
        label='Escalate Breached Case to Senior Queue'
    )
    public static void escalateCases(List<Request> requests) {

        Set<Id> caseIds = new Set<Id>();

        for (Request req : requests) {
            if (req.caseId != null) {
                caseIds.add(req.caseId);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        Group seniorQueue = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = 'HelpdeskPro_Tier_2_Support'
            LIMIT 1
        ];

        List<Case> casesToUpdate = new List<Case>();

        for (Id caseId : caseIds) {
            casesToUpdate.add(new Case(
                Id = caseId,
                Milestone_Breached__c = true,
                OwnerId = seniorQueue.Id
            ));
        }

        update casesToUpdate;
    }
}