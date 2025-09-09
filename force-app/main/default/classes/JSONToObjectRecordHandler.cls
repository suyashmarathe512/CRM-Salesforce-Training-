public with sharing class JSONToObjectRecordHandler {
    public static void JSONToRecord(List<JSON_To_Object_Record__e> newEvents) {
        for(JSON_To_Object_Record__e e : newEvents) {
            String jsonInput = e.JSON_Data__c ;
            String objName = e.Object_Name__c;
            List<SObject> ObjectList = (List<SObject>) JSON.deserialize(jsonInput, List<SObject>.class);
            for(SObject obj : ObjectList){
                System.debug('Record Id: ' + obj.Id + ', Record: ' + obj +
                ', Object Name: ' + objName);
            }
            Database.SaveResult[] results = Database.insert(ObjectList, false);
            for(Database.SaveResult result : results){
                if(result.isSuccess()){
                    System.debug('Successfully upserted Record with Id: ' + result.getId());
                } else {
                    for(Database.Error err : result.getErrors()){
                        System.debug('Error: ' + err.getMessage());
                    }
                }
            }
        }
    }

}