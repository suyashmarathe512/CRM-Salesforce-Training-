trigger UserTrigger on User (before insert, before update) {
    UserTriggerHandler.doNotDeactivate(Trigger.new,Trigger.oldMap);
    if(Trigger.isBefore && Trigger.isInsert){
        UserTriggerHandler.salesUserSetup(Trigger.new);    
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        UserTriggerHandler.salesUserSetup(Trigger.new);
    }

}