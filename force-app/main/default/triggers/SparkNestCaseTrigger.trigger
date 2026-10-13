trigger SparkNestCaseTrigger on Case (before update) {

    for (Case cs : Trigger.new) {

        Case oldCase = Trigger.oldMap.get(cs.Id);

        if (cs.Status == 'Closed' &&
            oldCase.Status != 'Closed') {

            Datetime closureTime = System.now();

            Long milliseconds =
                closureTime.getTime() - cs.CreatedDate.getTime();

            cs.Resolution_Time_Hours__c	=
                (Decimal) milliseconds / (1000 * 60 * 60);
        }
    }
}