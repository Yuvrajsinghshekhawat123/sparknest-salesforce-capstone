
global class HelpdeskProBreachedMilestoneScheduler
    implements Schedulable {

    global void execute(SchedulableContext sc) {

        Database.executeBatch(
            new HelpdeskProBreachedMilestoneBatch(),
            200
        );
    }
}
