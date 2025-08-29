trigger ContactDuplicateCheck on Contact (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            ContactDuplicateCheckHandler.checkDuplicates(Trigger.new);
        }
    }
}