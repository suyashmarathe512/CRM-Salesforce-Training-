trigger ContactsTrigger on Contact (before insert,  before update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        CheckForDupicates(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        CheckForDupicates(Trigger.new);
    }

}