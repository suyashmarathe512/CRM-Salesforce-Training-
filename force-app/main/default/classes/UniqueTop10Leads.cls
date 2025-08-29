public with sharing class UniqueTop10Leads {
    public uniqueTop10Leads() {
        List<AggregateResult> results = [SELECT Count(Id) totalLeads , LeadSource FROM Lead
            GROUP BY LeadSource  
            HAVING Count(Id) > 10];
        for (AggregateResult ar : results) {
                    System.debug('Lead Source: ' + ar.get('LeadSource') + ' | Total Leads: ' + ar.get('totalLeads'));
        }
    }
} 
/*
UniqueTop10Leads obj = new UniqueTop10Leads();
*/