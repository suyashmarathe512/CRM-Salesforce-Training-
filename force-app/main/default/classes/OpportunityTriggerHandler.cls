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
             try {
                List<OpportunityLineItem> oliList = [
                SELECT Id, UnitPrice, OpportunityId, Quantity
                FROM OpportunityLineItem
                WHERE OpportunityId IN :oppIdsToUpdate AND Quantity >= 2];
                Map<Id, Decimal> oppDiscountMap = new Map<Id, Decimal>();
                for (Opportunity opp : newOpps) {
                    if (oppIdsToUpdate.contains(opp.Id)) {
                        oppDiscountMap.put(opp.Id, opp.Line_Item_Discount__c);
                    }
                }
                for (OpportunityLineItem oli : oliList) {
                    Decimal discount = oppDiscountMap.get(oli.OpportunityId);
                    if (discount != null && discount > 0 && discount < 100 && oli.Quantity >= 2) {
                        oli.UnitPrice = oli.UnitPrice * (1 - discount / 100);
                    } else {
                            Logs__c l = new Logs__c();
                            l.Error__c = 'No valid discount for OLI Id: ' + oli.Id + ' (discount=' + String.valueOf(discount) + ')';
                            errorLogs.add(l);
                        }
                }
                Database.SaveResult[] oliResults = Database.update(oliList, false);
                for (Integer i = 0; i < oliResults.size(); i++) {
                    if (!oliResults[i].isSuccess()) {
                        for (Database.Error err : oliResults[i].getErrors()) {
                            Logs__c l = new Logs__c();
                            l.Error__c = 'OpportunityLineItem Id: ' + oliList[i].Id + '. Reason: ' + err.getMessage();
                            errorLogs.add(l);
                        }
                    }
                }
                if (!errorLogs.isEmpty()) {
                    Database.SaveResult[] logResults = Database.insert(errorLogs);
                }
            }   
            catch (Exception e) {
                System.debug('updateOpportunityProductsWithDiscount Exception: ' + e.getMessage());
            }
        }
    }

}