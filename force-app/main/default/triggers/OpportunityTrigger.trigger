trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
        	OpportunityTriggerHandler.checkDescriptionForClosedWon(Trigger.new);
    	}
    }
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            OpportunityTriggerHandler.calculateSalesPrice(Trigger.new);
        }
    }
}