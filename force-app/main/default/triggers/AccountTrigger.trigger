trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        //AccountTriggerHandler.cloneRecord(Trigger.new);
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate) {
            Database.executeBatch(new DuplicateContactBatch(), 200);
            Database.executeBatch(new DuplicateOpportunitiesBatch(), 200);
        }
    }
}