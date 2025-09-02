public with sharing class OpportunityTriggerHandler {
    public static void checkDescriptionForClosedWon(List<Opportunity> newOpportunities) {
        for(Opportunity opp: newOpportunities){
            if(opp.StageName == 'Closed Won' && opp.Description == null){
                opp.addError('Description is required for closed won opportunities');
            }
        }
    }
    public static void calculateSalesPrice(List<Opportunity> newOpportunities){
        for(Opportunity opp: newOpportunities){
            if(opp.Price__c != null && opp.Quantity__c != null){
                opp.Sales_Price__c = opp.Price__c * opp.Quantity__c;
            }
        }
    }
}