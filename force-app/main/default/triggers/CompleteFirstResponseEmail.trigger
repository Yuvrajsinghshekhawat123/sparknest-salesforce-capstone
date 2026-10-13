trigger CompleteFirstResponseEmail on EmailMessage (after insert) {
    Set<Id> caseIds = new Set<Id>();

    for (EmailMessage email : Trigger.new) {
        if (!email.Incoming) {
            Id targetCaseId = null;

            // Check ParentId
            if (email.ParentId != null && email.ParentId.getSObjectType() == Case.SObjectType) {
                targetCaseId = email.ParentId;
            } 
            // Fallback to RelatedToId
            else if (email.RelatedToId != null && email.RelatedToId.getSObjectType() == Case.SObjectType) {
                targetCaseId = email.RelatedToId;
            }

            if (targetCaseId != null) {
                caseIds.add(targetCaseId);
            }
        }
    }

    if (!caseIds.isEmpty()) {
        MilestoneUtils.completeMilestone(
            caseIds,
            'First Response as the milestone name and save.',
            System.now()
        );
    }
}