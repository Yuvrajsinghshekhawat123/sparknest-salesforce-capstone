global class HelpdeskProBreachedMilestoneBatch implements Database.Batchable<CaseMilestone>,
               Database.Stateful {

    // Replace with the Support Manager's email address.
    global String managerEmail = 'supportmanager@helpdeskpro.in';
    global String emailRows = '';
    global Integer breachedCount = 0;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, TargetDate, IsCompleted, IsViolated,
                MilestoneType.Name,Case.CaseNumber,Case.Account.Name,Case.Contact.Name
            FROM CaseMilestone WHERE IsViolated = true AND IsCompleted = false
              AND MilestoneType.Name = 'Resolution' AND Case.IsClosed = false
        ]);
    }

    global void execute(Database.BatchableContext bc,List<CaseMilestone> scope) {
        for (CaseMilestone cm : scope) {

            Decimal overdueHours = (
                System.now().getTime()
                - cm.TargetDate.getTime()
            ) / 3600000.0;

            String customerName = 'Not specified';

            if (cm.Case.Account != null) {
                customerName = cm.Case.Account.Name;
            } else if (cm.Case.Contact != null) {
                customerName = cm.Case.Contact.Name;
            }

            emailRows += '<tr><td>'
                + cm.Case.CaseNumber
                + '</td><td>'
                + customerName.escapeHtml4()
                + '</td><td>'
                + String.valueOf(overdueHours.setScale(2))
                + '</td></tr>';

            breachedCount++;
        }
    }

    global void finish(Database.BatchableContext bc) {

        if (breachedCount == 0) {
            return;
        }

        String emailBody =
            '<h2>HelpdeskPro Resolution SLA Breach Report</h2>'
            + '<p>Total breached open Cases: '
            + breachedCount + '</p>'
            + '<table border="1" cellpadding="6" '
            + 'cellspacing="0">'
            + '<tr><th>Case Number</th>'
            + '<th>Customer Name</th>'
            + '<th>Hours Overdue</th></tr>'
            + emailRows
            + '</table>';

        Messaging.SingleEmailMessage email =
            new Messaging.SingleEmailMessage();

        email.setToAddresses(
            new String[] { managerEmail }
        );
        email.setSubject(
            'HelpdeskPro: Nightly Resolution SLA Breach Report'
        );
        email.setHtmlBody(emailBody);
        email.setSaveAsActivity(false);

        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { email }
        );
    }
}
