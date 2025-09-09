trigger JSONToObjectRecord on JSON_To_Object_Record__e (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
            JSONToObjectRecordHandler.JSONToRecord(Trigger.new);
        }
}