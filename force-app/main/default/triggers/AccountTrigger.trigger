trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        //Update Text For PR Review
        AccountTriggerHandler.cloneRecord(Trigger.new);
    }
}