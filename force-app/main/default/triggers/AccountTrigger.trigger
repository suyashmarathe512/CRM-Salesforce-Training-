trigger AccountTrigger on Account (after insert, after update) {
    List<Account> clonedAccounts = new List<Account>();
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.CloneRecord(Trigger.new);
    }
}