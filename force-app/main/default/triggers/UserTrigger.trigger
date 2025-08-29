trigger UserTrigger on User (after insert, after update, before update) {

    if(Trigger.isAfter && Trigger.isInsert){
        UserTriggerHandler.(Trigger.new);
    }

}