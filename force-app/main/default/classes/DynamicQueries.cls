public with sharing class DynamicQueries {
    // 1. Fetch all Text field names of an object dynamically
    public static List<String> GetTextFieldNames(String objectName) {
        List<String> textFields = new List<String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        if (gd.containsKey(objectName)) {
            Schema.SObjectType objName = gd.get(objectName);
            system.debug('Object Name: ' + objName);
            Map<String, Schema.SObjectField> fields = objName.getDescribe().fields.getMap();
            system.debug('Fields: ' + fields);
            system.debug('fields.values(): ' + fields.values());
            for (Schema.SObjectField field : fields.values()) {
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                system.debug('Field Describe: '+field+ ':--' + fieldDesc);
                if (fieldDesc.getType() == Schema.DisplayType.String) {
                    system.debug('The type: ' + fieldDesc.getType());
                    textFields.add(fieldDesc.getName());
                    system.debug('Text Field Added: ' + fieldDesc.getName());
                }
            }
        }
        system.debug('Text Fields: ' + textFields);
        return textFields;
    }
/*
DynamicQueries.GetTextFieldNames('Account');
*/
    
    public static List<SObject> FetchRecords(String objectName) {
        List<String> fields = GetTextFieldNames(objectName);
        String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectName + ' LIMIT 5';
        
        return Database.query(soql);

    }
    /*
    List<SObject> records = DynamicQueries.FetchRecords('Account');
    system.debug('------------------------------------------------------------');
    for(SObject record : records) {
        system.debug('Record: ' + record);
    }
    */

    

    
    public static List<SObject> FetchRecordsWithFilter(String objectName, String filterValue) {
        List<String> fields = GetTextFieldNames(objectName);
        if (fields.isEmpty()) return new List<SObject>();
        String firstField = fields[0];
        String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectName +
                      ' WHERE ' + firstField + ' = :filterValue LIMIT 5';
        return Database.query(soql);
    }
    /*
    List<SObject> records = DynamicQueries.FetchRecordsWithFilter('Account', 'Pyramid Construction Inc.');
    system.debug('------------------------------------------------------------');
    for(SObject record : records) {
        system.debug('Record: ' + record);
    }
    */

    
    public static List<SObject> FetchRecordsAdvanced(
        String objectName,
        String filterValue,
        String orderByField,
        String orderDirection,
        Integer limitSize,
        Integer offsetSize
    ) {
        List<String> fields = GetTextFieldNames(objectName);
        String firstField = fields[0];
        String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + objectName +
                      ' WHERE ' + firstField + ' = :filterValue' +
                      ' ORDER BY ' + orderByField + ' ' + orderDirection +
                      ' LIMIT ' + limitSize +
                      ' OFFSET ' + offsetSize;
        return Database.query(soql);
    }
    /*
    List<SObject> records = DynamicQueries.FetchRecordsAdvanced(
        'Account', 'Pyramid Construction Inc.', 'Name', 'ASC', 5, 0
    );      
    system.debug('------------------------------------------------------------');
    for(SObject record : records) {
        system.debug('Record: ' + record);  
    */
}