public with sharing class DMLOperations {
    public static void createLeadsWithLogging() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 101; i <= 200; i++) {
            Lead l = new Lead();
            l.LastName = 'Lead' + i;
            if(Math.mod(i, 10) != 0){
                l.Company = 'Company' + i;
            }
            l.Status = 'Open - Not Contacted';
            leads.add(l);
        }
        Database.SaveResult[] results = Database.insert(leads, False);
        List<Logs__c> logs = new List<Logs__c>();
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                String errorMsg = '';
                for (Database.Error err : results[i].getErrors()) {
                    errorMsg += err.getMessage() + ' ';
                }
                Logs__c log = new Logs__c();
                log.Error__c = 'Lead Name: ' + leads[i].LastName + '. Reason: ' + errorMsg.trim();
                logs.add(log);
            }
        }
        if (!logs.isEmpty()) {
            insert logs;
        }
    }
/*
DMLOperations obj = new DMLOperations();
DMLOperations.CreateLeadsWithLogging();
*/
    public static void deleteInactiveRecentAccounts() {
        DateTime ninetyDaysAgo = System.now().addDays(-90);
        List<Account> accountsToDelete = [
            SELECT Id FROM Account
            WHERE Active__c = 'No'
            AND CreatedDate >= :ninetyDaysAgo
        ];
        delete accountsToDelete;
        
    }
    /*
    DMLOperations obj = new DMLOperations();
    DMLOperations.DeleteInactiveRecentAccounts();
    */
    public void assestsWithLineItemsId(){
            Asset newAsset = new Asset();
            newAsset.Line_Item_Id__c = '123';
            newAsset.SerialNumber = '3456';
            newAsset.Price = 10000;
            upsert newAsset Line_Item_Id__c;
    }
    /*
    DMLOperations obj = new DMLOperations();
    obj.AssestsWithLineItemsId();
    */

    public static void printCampaignsSorted() {
        List<Campaign> campaignsAsc = [SELECT Id, Name FROM Campaign ORDER BY Name ASC LIMIT 10];
        System.debug('Campaigns Ascending:');
        for (Campaign c : campaignsAsc) {
            System.debug('Id: ' + c.Id + ', Name: ' + c.Name);
        }
        List<Campaign> campaignsDesc = [SELECT Id, Name FROM Campaign ORDER BY Name DESC LIMIT 10];
        System.debug('Campaigns Descending:');
        for (Campaign c : campaignsDesc) {
            System.debug('Id: ' + c.Id + ', Name: ' + c.Name);
        }
    }

/*
DMLOperations obj = new DMLOperations();
DMLOperations.PrintCampaignsSorted();
*/
    public static void printContactsModifiedToday() {
        Date today = Date.today();
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, LastModifiedDate 
            FROM Contact
            WHERE LastModifiedDate = TODAY()
        ];
        System.debug('Contacts modified today:');
        for (Contact c : contacts) {
            System.debug('Id: ' + c.Id + ', Name: ' + c.FirstName + ' ' + c.LastName + ', LastModifiedDate: ' + c.LastModifiedDate);
        }
    }
/*
DMLOperations obj = new DMLOperations();
DMLOperations.PrintContactsModifiedToday();
*/
}