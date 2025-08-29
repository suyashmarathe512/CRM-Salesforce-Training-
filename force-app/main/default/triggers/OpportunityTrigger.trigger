trigger OpportunityTrigger on Opportunity (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityTriggerHandler.checkDescriptionForClosedWon(Trigger.new);
    }

}