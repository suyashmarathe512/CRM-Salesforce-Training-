public with sharing class OpportunityGreaterThan10000 {
    public OpportunityGreaterThan10000(){
        List<Opportunity> allOpportunities = [SELECT Id, Name, Amount, CreatedDate,IsDeleted
                                              FROM Opportunity 
                                              WHERE Amount > 10000 
                                              ORDER BY CreatedDate DESC 
                                              NULLS LAST LIMIT 100 OFFSET 5 ALL ROWS];
		for(Opportunity opp: allOpportunities)
        {    
        	system.debug(opp);
        }
    }
}
/*
OpportunityGreaterThan10000 obj = new OpportunityGreaterThan10000();
*/