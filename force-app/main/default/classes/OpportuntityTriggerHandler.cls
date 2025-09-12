public with sharing class OpportunityTriggerHandler {
     public static void calculateSalesPrice(List<Opportunity> newOpportunities) {
        Set<Id> oppIdsToUpdate = new Set<Id>();
        List<Logs__c> errorlogs = new List<Logs__c>();
        Decimal totalSalesPrice = 0;
        for(Opportunity opp : newOpportunities) {
            oppIdsToUpdate.add(opp.Id);
        }
        try{
            List<OpportunityLineItem> oliList = [
                    SELECT Id, UnitPrice, OpportunityId, Quantity
                    FROM OpportunityLineItem
                    WHERE OpportunityId IN :oppIdsToUpdate];            
            for(Opportunity opp : newOpportunities) {
                if(!oliList.isEmpty()){
                    for(OpportunityLineItem oli : oliList){ 
                        totalSalesPrice += oli.UnitPrice;
                        opp.Sales_Price__c = totalSalesPrice;
                        }
                    }
                else{
                    opp.Sales_Price__c = 0;
                } 
                }
            }
        catch(Exception e){
            Logs__c log = new Logs__c();
            log.Source_Object__c = 'Opportunity';
            log.Error_Causing_Class_Method__c = 'calculateSalesPrice';
            log.Import_Date__c = Date.today();
            log.Severity__c = 'Mid';
            log.Type__c = 'System exceptions';
            log.Message_Long__c  = e.getMessage() + ' ' + e.getCause() + ' ' 
                                    + e.getLineNumber() + ' ' + e.getTypeName() +
                                     '' + e.getInaccessibleFields(); 
            log.Stack_Trace__c = e.getStackTraceString();
            log.Error__c= e.getMessage();
            errorlogs.add(log);
            insert errorlogs;
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
                WHERE OpportunityId IN :oppIdsToUpdate];
                Map<Id, Decimal> oppDiscountMap = new Map<Id, Decimal>();
                for (Opportunity opp : newOpps) {
                    if (oppIdsToUpdate.contains(opp.Id)) {
                        oppDiscountMap.put(opp.Id, opp.Line_Item_Discount__c);
                    }
                }
                for (OpportunityLineItem oli : oliList) {
                    Decimal discount = oppDiscountMap.get(oli.OpportunityId);
                    if (discount != null) {
                        oli.UnitPrice = oli.UnitPrice * (1 - discount / 100);
                    } 
                }
            }   
            catch (Exception e) {
                Logs__c log = new Logs__c();
                log.Source_Object__c = 'Opportunity';
                log.Error_Causing_Class_Method__c = 'calculateSalesPrice';
                log.Import_Date__c = Date.today();
                log.Severity__c = 'Mid';
                log.Message_Long__c = e.getMessage() + ' ' + e.getCause() + ' ' 
                                    + e.getLineNumber() + ' ' + e.getTypeName() +
                                     '' + e.getInaccessibleFields(); 
                log.Stack_Trace__c = e.getStackTraceString();
                log.Error__c= e.getMessage();
                errorlogs.add(log);
                insert errorlogs;
            }
        }
    }
}
