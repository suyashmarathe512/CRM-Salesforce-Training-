public with sharing class ApexPart2 {
    public static List<Account> printPersonAccountIdsTraditional() {
        List<Account> accList = [SELECT Id,Name, IsPersonAccount FROM Account];
        for (Integer i = 0; i < accList.size(); i++) {
            if (accList[i].IsPersonAccount) {
                System.debug('Person Account ID: ' + accList[i].Id + 'Name: ' + accList[i].Name);
            }
        }
        return accList;
    }
    /*
    ApexPart2.PrintPersonAccountIdsTraditional();
    */
    public static void printPersonAccountIdsAdvanced() {
        for (Account acc : [SELECT Id,Name, IsPersonAccount FROM Account]) {
            if (acc.IsPersonAccount) {
                System.debug('Person Account ID: ' + acc.Id + 'Name: ' + acc.Name) ;
            }
        }
        
    }
    /*
    ApexPart2.PrintPersonAccountIdsAdvanced();
    */
    public static List<Id> printClosedOpportunityIds() {
        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE IsClosed = true AND AccountId != null];
        List<Id> oppIds = new List<Id>();
        for (Opportunity opp : oppList) {
            oppIds.add(opp.Id);
        }
        System.debug('Closed Opportunity IDs: ' + oppIds);
        return oppIds;
    }
    /*
    ApexPart2.PrintClosedOpportunityIds();
    */
    public static Set<Id> printClosedOpportunityAccountIds() {
        List<Opportunity> oppList = [SELECT AccountId FROM Opportunity WHERE IsClosed = true AND AccountId != null];
        Set<Id> accIds = new Set<Id>();
        for (Opportunity opp : oppList) {
            accIds.add(opp.AccountId);
        }
        System.debug('Account IDs from Closed Opportunities: ' + accIds);
        return accIds;
    }
    /*
    ApexPart2.printClosedOpportunityAccountIds();
    */
    public static Map<Id, Id> printOpportunityAccountMap() {
        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE IsClosed = true AND AccountId != null];
        Map<Id, Id> oppAccMap = new Map<Id, Id>();
        for (Opportunity opp : oppList) {
            oppAccMap.put(opp.Id, opp.AccountId);
        }
        System.debug('OpportunityId to AccountId Map: ' + oppAccMap);
        return oppAccMap;
    }
    /*
    ApexPart2.printOpportunityAccountMap();
    */
    public static List<Account> updateAccountsStartingWithA() {
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name LIKE 'a%'];
        System.debug('Accounts starting with "a": ' + accList.size());
        for (Account acc : accList) {
            acc.Name = 'Updated';
        }
            update accList;  
            return accList;
    }
    /*
    ApexPart2.updateAccountsStartingWithA();
    for(Account acc : [SELECT Id, Name FROM Account WHERE Name = 'Updated']){
        System.debug('Updated Account: ' + acc.Id + ' | Name: ' + acc.Name);
    }
    */
    public static Map<Id, List<Opportunity>> accountIDWithOpportunityValue(){
        Map<Id, List<Opportunity>> accOppMap = new Map<Id, List<Opportunity>>();
        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE AccountId != null];
        for (Opportunity opp : oppList) {
            if (!accOppMap.containsKey(opp.AccountId)) {
                accOppMap.put(opp.AccountId, new List<Opportunity>());
            }
            accOppMap.get(opp.AccountId).add(opp);
        }
        for(Id key : accOppMap.keySet()){
            System.debug('Opportunity Ids for Account ' + key + ': ' + accOppMap.get(key));
        }
        return accOppMap;
    }
    /*
    ApexPart2.AccountIDWithOpportunityValue();
    */
    public static Object divide(Integer a, Integer b) {
        try {
            if (b == 0) {
                system.debug('Cannot divide by zero');
            }
            return a / b;
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    /*
    System.debug(ApexPart2.Divide(10, 2)); 
    System.debug(ApexPart2.Divide(10, 0)); 
    */  
    public static Map<Datetime, List<Account>> verifyAccountCreatedOnDate(){
        List<Account> accList = [SELECT Id, Name, CreatedDate FROM Account];
        Map<Datetime, List<Account>> accMapByDate = new Map<Datetime, List<Account>>();
        for(Account acc : accList){
            if(!accMapByDate.containsKey(acc.CreatedDate)){
                accMapByDate.put(acc.CreatedDate, new List<Account>());
            }
            accMapByDate.get(acc.CreatedDate).add(acc);
        }
        for(Datetime key : accMapByDate.keySet()){
            System.debug('Account created on ' + key );
            for(Account acc : accMapByDate.get(key)){
                System.debug('Account Id: ' + acc.Id + ', Name: ' + acc.Name);
            }
        }
        return accMapByDate;
    }
    /*
    ApexPart2.VerifyAccountCreatedOnDate();
    */
    public static List<Account> listOfAccountInJSON(){
        List<Account> accList = [SELECT Id, Name FROM Account LIMIT 5];
        String jsonOutput = JSON.serialize(accList);
        System.debug('Accounts in JSON: ' + jsonOutput);
        return accList;
    }

    /*
    ApexPart2.listOfAccountInJSON();
    */
    public static void jSONToListOfAccount(String jsonInput){
        List<SObject> accList = (List<SObject>) JSON.deserialize(jsonInput, List<SObject>.class);
        for(SObject acc : accList){
            System.debug('Account Id: ' + acc.Id + ', Name: ' + acc.Name);
        }
        Database.UpsertResult[] results = Database.upsert(accList, false);
        for(Database.UpsertResult result : results){
            if(result.isSuccess()){
                System.debug('Successfully upserted Account with Id: ' + result.getId());
            } else {
                for(Database.Error err : result.getErrors()){
                    System.debug('Error: ' + err.getMessage());
                }
            }
        }
    }
    /*
    String jsonInput = '[{"Name":"JSON Test 1", "Phone":"123", "Rating": "Hot", "Active__c":"Yes"},{"Name":"JSON Test 2"}]';
    ApexPart2.jSONToListOfAccount(jsonInput);
    */
    public void dataOfCurrentUser(){
        User currentUser = [SELECT Id, Username, Email, Profile.Id, UserType FROM User WHERE Username = :UserInfo.getUserName()];
            system.debug('UserName: ' + currentUser.Username);
            system.debug('User Email: ' + currentUser.Email);
            system.debug('User Profile Id: ' + currentUser.Profile.Id);
            system.debug('User UserType: ' + currentUser.UserType);
        
    }
    /*
    ApexPart2 obj = new ApexPart2();
    obj.dataOfCurrentUser();
    */
    public static void updateRecordBasedOnValues(String objName, String fieldName, Object fieldValue, Id recordId) {
        try {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            if(!gd.containsKey(objName)) {
                System.debug('Error: Invalid object name -> ' + objName);
                return;
            }
            Schema.SObjectType sObjType = gd.get(objName);
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            if(!fieldMap.containsKey(fieldName)) {
                System.debug('Error: Invalid field name -> ' + fieldName);
                return;
            }
            String query = 'SELECT Id, ' + fieldName + ' FROM ' + objName + ' WHERE Id = :recordId';
            SObject record = Database.query(query);
            if(record == null) {
                System.debug('Error: No record found with Id -> ' + recordId);
                return;
            }
            System.debug('Old Record was: ' + record);
            record.put(fieldName, fieldValue);
            update record;
            System.debug('Record is updated successfully : ' + record);
        } catch (Exception e) {
            System.debug('Error while updating record: ' + e.getMessage());
        }
    }
    /*
    ApexPart2.UpdateRecordBasedOnValues('Account','Name', 'Aurther', '001d200000rjXxXAAU');
    */
}