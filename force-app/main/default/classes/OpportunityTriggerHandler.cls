public with sharing class OpportunityTriggerHandler {
    public static void checkDescriptionForClosedWon(List<Opportunity> newOpportunities) {
        for(Opportunity opp: newOpportunities){
            if(opp.StageName == 'Closed Won' && opp.Description == null){
                opp.addError('Description is required for closed won opportunities');
            }
        }
    }
    public static void updateOpportunityProductsWithDiscount(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap) {
        Set<Id> oppIdsToUpdate = new Set<Id>();
        List<Logs__c> errorlogs = new List<Logs__c>();
        for(Opportunity opp : newOpps) {
            if(opp.Line_Item_Discount__c != oldMap.get(opp.Id).Line_Item_Discount__c) {
                oppIdsToUpdate.add(opp.Id);
            }
        }
        if(!oppIdsToUpdate.isEmpty()) {
            try{
                List<OpportunityLineItem> oppolineItems = [
                        SELECT Id, UnitPrice, OpportunityId, Quantity 
                        FROM OpportunityLineItem
                        WHERE OpportunityId IN :oppIdsToUpdate AND Quantity >= 2
                    ];
                Map<Id, Decimal> oppDiscountMap = new Map<Id, Decimal>();
                for(Opportunity opp : newOpps) {
                    if(oppIdsToUpdate.contains(opp.Id)) {
                        oppDiscountMap.put(opp.Id, opp.Line_Item_Discount__c);
                    }
                }
                for(OpportunityLineItem oli: oppolineItems) {
                    Decimal discount = oppDiscountMap.get(oli.OpportunityId);
                    if(discount != null && discount > 0 && discount < 100 
                        && oli.Quantity >= 2){
                        oli.UnitPrice = oli.UnitPrice * (1 - discount / 100);
                    }
                    else{
                        oli.addError('');
                    }
                }
                Database.UpsertResult[] results = Database.upsert(oppolineItems, false);
                for (Integer i = 0; i < results.size(); i++) {
                    if(!results[i].isSuccess()){
                            for(Database.Error err : results[i].getErrors()){
                                Logs__c log = new Logs__c();
                                log.Error__c = 'Opportunity Line Item Id: ' + oppolineItems[i].Id + '. Reason: ' + err.getMessage();
                                errorlogs.add(log);
                            }
                    }
                }
            }
            catch(Exception e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
}

