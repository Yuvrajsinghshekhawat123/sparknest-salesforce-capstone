trigger SparkNestBankingAccountTrigger on Account (after insert) {
    SparkNestBankingAccountTriggerHandler.handleAfterInsert(
        Trigger.new
    );
}