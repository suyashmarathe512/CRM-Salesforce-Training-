public with sharing class JSONToObjectRecordHandler implements Database.Stateful {
    public static List<JSON_To_Object_Record__e> processedEvents = new List<JSON_To_Object_Record__e>();
    public static Set<String> processedEventUuids = new Set<String>();
    public static void processEvents(List<JSON_To_Object_Record__e> events) {
        List<SObject> ObjectList;
        List<Logs__c> errorLogs = new List<Logs__c>();
        for(JSON_To_Object_Record__e e : events) {
            String jsonInput = e.JSON_Data__c;
            String objName = e.Object_Name__c;
            String eventUuid = e.EventUuid;
            if(!processedEventUuids.contains(eventUuid)){
                System.debug('Processing event with eventUuid: ' + eventUuid);
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
                String dataJson = JSON.serialize(jsonMap.get('data'));
                ObjectList = (List<SObject>) JSON.deserialize(dataJson, List<SObject>.class);
                for(SObject obj : ObjectList){
                    System.debug('Record: ' + obj + ', Object Name: ' + objName + ', EventUuid: ' + eventUuid);
                }
                processedEventUuids.add(eventUuid);
            }
            Database.SaveResult[] results = Database.insert(ObjectList, false);
            for(Database.SaveResult result : results){
                if(result.isSuccess()){
                    System.debug('Successfully upserted Record with Id: ' + result.getId());
                } else {
                    for(Database.Error err : result.getErrors()){
                        Logs__c log = new Logs__c();
                        log.Error__c = err.getMessage();
                        log.Source_Object__c = 'JSON_To_Object_Record__e';
                        errorLogs.add(log);
                    }
                }
            }
            processedEvents.add(e);
        }
        if(!errorLogs.isEmpty()){
            insert errorLogs;
        }
    }
}
