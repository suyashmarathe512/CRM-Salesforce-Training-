public with sharing class OpportuntityTriggerHandler {
    public static void checkDescriptionForClosedWon(List<Opportunity> newOpportunities) {
        for(Opportunity opp: newOpportunities){
            if(opp.IsClosed && opp.IsWon && opp.Description == null){
                opp.addError('Description is required for closed won opportunities');
                //Rahul
            }
        }
    }
}