public with sharing class SumClosedOpportunityOfCurrentFiscalYear {
    public SumClosedOpportunityOfCurrentFiscalYear() {
        List<Opportunity> opportunityList = new List<Opportunity>([SELECT Id,Name,SUM(Amount) 
        FROM Opportunity 
        WHERE CloseDate = THIS_FISCAL_YEAR 
        GROUP BY Name 
        HAVING CloseDate = THIS_FISCAL_YEAR]);    
        System.debug(opportunityList);
    }
}


/*
SumClosedOpportunityOfCurrentFiscalYear obj = new SumClosedOpportunityOfCurrentFiscalYear();
*/            result += 'Year: ' + year + ' | Total Amount: $' + stats.get(year).format() + ' USD\n';
