trigger ContactTrigger on Contact (before insert,  before update, after insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            ContactTriggerHandler.checkDuplicates(Trigger.new);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            ContactTriggerHandler.associateAccountWithContact(Trigger.new);
        }
    }
}