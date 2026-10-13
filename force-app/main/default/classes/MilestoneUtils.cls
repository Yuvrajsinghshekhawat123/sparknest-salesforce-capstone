public with sharing class MilestoneUtils {
    public static void completeMilestone(
        Set<Id> caseIds,
        String milestoneName,
        Datetime completionDate
    ) {
        if (caseIds == null || caseIds.isEmpty()) {
            return;
        }

        // Using LIKE avoids failure if whitespace differs slightly
        String nameFilter = '%' + milestoneName.trim() + '%';

        List<CaseMilestone> milestonesToUpdate = [
            SELECT Id, CaseId, CompletionDate, MilestoneType.Name
            FROM CaseMilestone
            WHERE CaseId IN :caseIds
            AND MilestoneType.Name LIKE :nameFilter
            AND IsCompleted = false
        ];

        for (CaseMilestone milestone : milestonesToUpdate) {
            milestone.CompletionDate = completionDate;
        }

        if (!milestonesToUpdate.isEmpty()) {
            update as system milestonesToUpdate;
        }
    }
}