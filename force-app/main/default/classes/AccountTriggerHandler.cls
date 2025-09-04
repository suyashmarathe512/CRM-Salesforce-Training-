public with sharing class AccountTriggerHandler {
    public static Boolean HasRun = false;
    public static void cloneRecord(List<Account> newAccounts) {
        if(HasRun) {
            return;
                   }
       	HasRun = true;
        List<Account> clonedAccounts = new List<Account>();
        for(Account acc : newAccounts) {
            Account clonedAcc = acc.clone();
            clonedAcc.Name = acc.Name + ' - Clone';
            clonedAccounts.add(clonedAcc);
        }
        insert clonedAccounts;
    }
    public static void logCollectionOnInsert(List<Account> newAccounts){
        Database.SaveResult[] results = Database.insert(newAccounts, false);
        for(account acc: newAccounts){
            if(results.size() > 0){
                List<Logs__c> logs = new List<Logs__c>();
                for (Integer i = 0; i < results.size(); i++) {
                    if (!results[i].isSuccess()) {
                        String errorMsg = '';
                        for (Database.Error err : results[i].getErrors()) {
                            errorMsg += err.getMessage() + ' ';
                        }
                        Logs__c log = new Logs__c();
                        log.Source_Object__c = 'Account ' + acc.Id;
                        Log.Noisy_Record__c = acc;
                        Log.Import_Date__c = Date.today();
                        log.Error__c = errorMsg.trim();
                        logs.add(log);
                    }
                }
            }
        }
        if (!logs.isEmpty()) {
                    insert logs;
        }
    } 
}