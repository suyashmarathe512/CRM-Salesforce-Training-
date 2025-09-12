@isTest
public class JSONToObjectRecordHandlerTest {
    @isTest
    static void testInsertRecordsFromPlatformEvent() {
        String objectName = 'Account';
        String jsonData = '[{"attributes":{"type":"' + objectName + '"},"Name": "Test Account Event"}]';
        JSON_To_Object_Record__e testEvent = new JSON_To_Object_Record__e(
            JSON_Data__c = jsonData,
            Object_Name__c = objectName
        );
        Test.startTest();
        EventBus.publish(testEvent);
        Test.stopTest();

        String query = 'SELECT Id, Name FROM ' + objectName +
                            ' WHERE Name = \'Test Account Event\'';
        List<SObject> insertedRecords = Database.query(query);
        System.assertEquals(1, insertedRecords.size(), 'One ' 
                            + objectName + ' should be inserted');
        System.assertEquals('Test Account Event', insertedRecords[0].get('Name'), 
                                objectName + ' name should match');
    }
    @isTest
    static void testCheckDuplicatesRecordFromPlatformEvent(){
        String objectName = 'Account';
        String jsonData = '[{"attributes":{"type":"' + objectName + '"},"Name": "Test Account Event"}]';
        JSON_To_Object_Record__e testEvent = new JSON_To_Object_Record__e
            (JSON_Data__c = jsonData,
            Object_Name__c = objectName
            );
        Account testAccount = new Account(Name = 'Test Account Event');
        insert testAccount;
        Test.startTest();
        EventBus.publish(testEvent);
        Test.stopTest();
        String query = 'SELECT Id, Name FROM ' + objectName +
                            ' WHERE Name = \'Test Account Event\'';
        List<SObject> insertedRecords = Database.query(query);
        System.assertEquals(1, insertedRecords.size(), 'One ' 
                            + objectName + ' should be inserted');
    }
}
