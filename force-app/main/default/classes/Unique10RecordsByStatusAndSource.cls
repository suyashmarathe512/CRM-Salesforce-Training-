public with sharing class Unique10RecordsByStatusAndSource {
    public Unique10RecordsByStatusAndSource() {
        Map<String, Map<String, Integer>> statusLeadSourceMap = new Map<String, Map<String, Integer>>();
        for (AggregateResult ar : [
            SELECT Status, LeadSource, COUNT(Id) total
            FROM Lead
            GROUP BY Status, LeadSource
            ORDER BY COUNT(Id) DESC NULLS LAST])
            {
            String status = (String)ar.get('Status');
            String leadSource = (String)ar.get('LeadSource');
            Integer countVal = (Integer)ar.get('total');
            if (!statusLeadSourceMap.containsKey(status)){
                statusLeadSourceMap.put(status, new Map<String, Integer>());
            }
            statusLeadSourceMap.get(status).put(leadSource, countVal);
        }
        for (String statusKey : statusLeadSourceMap.keySet()) {
            System.debug('Status: ' + statusKey);
            for (String sourceKey : statusLeadSourceMap.get(statusKey).keySet()) {
                System.debug('   LeadSource: ' + sourceKey +  ' | Count: ' + statusLeadSourceMap.get(statusKey).get(sourceKey));
            }
        }

    }
}
/*
Unique10RecordsByStatusAndSource obj = new Unique10RecordsByStatusAndSource();
*/