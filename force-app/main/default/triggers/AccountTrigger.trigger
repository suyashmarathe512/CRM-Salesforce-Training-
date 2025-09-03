trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.cloneRecord(Trigger.new);
    }
}
//Updated for the Review.