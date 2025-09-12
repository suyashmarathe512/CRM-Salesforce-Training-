trigger JSONToObjectRecord on JSON_To_Object_Record__e (after insert) {
    JSONToObjectRecordHandler.processEvents(Trigger.new);
}
