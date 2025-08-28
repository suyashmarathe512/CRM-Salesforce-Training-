public with sharing class SumAmountClosedOpportunityOfFiscalYear {
    public SumAmountClosedOpportunityOfFiscalYear() {
        List<AggregateResult> TotalAmount =[SELECT FiscalYear, SUM(Amount) Total
        FROM Opportunity WHERE (StageName = 'Closed Won') 
        GROUP BY FiscalYear];
       Map<Integer, Decimal> oppStats = new Map<Integer, Decimal>();
        for (AggregateResult ar : TotalAmount) {
            Integer yearVal = (Integer) ar.get('FiscalYear');
            Decimal Totalsum = (Decimal)ar.get('Total');
            oppStats.put(yearVal, Totalsum);
        }
        for (Integer yearKey : oppStats.keySet()) {
            system.debug('Year: ' + yearKey + ' | Total Closed Opportunity Amount: ' + oppStats.get(yearKey));
        }
    }
}


/*
SumAmountClosedOpportunityOfFiscalYear obj = new SumAmountClosedOpportunityOfFiscalYear();
*/