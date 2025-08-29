public with sharing class OpportunityTriggerHandler {
    public static void checkDescriptionForClosedWon(List<Opportunity> newOpportunities) {
        for(Opportunity opp: newOpportunities){
            if(opp.StageName == 'Closed Won' && opp.Description == null){
                opp.addError('Description is required for closed won opportunities');
            }
        }
    }
}