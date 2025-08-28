public with sharing class RelationshipQueries {
    public void allActiveContactsFromMedia(){
            List<Contact> mylist = [SELECT Id, Name, Email, Account.Name, Account.Industry
                FROM Contact
                WHERE Account.Active__c = 'Yes' 
                AND Account.Industry = 'Media'];
            for(Contact myContact : mylist){
                system.debug('Name: ' + myContact.Name + '| Account Name: ' 
                + myContact.Account.Name + '| Industry: '  + myContact.Account.Industry);
            }
    }

/*
RelationshipQueries obj = new RelationshipQueries();
obj.AllActiveContactsFromMedia();
*/
    public void allCRecordsWithParentDetails(){
        List<C__c> Clist = [SELECT Name, A__r.Name, B__r.Name FROM C__c WHERE Name LIKE 'John%'];
        for(C__c myrecord : Clist){
            system.debug('Name: ' + myrecord.Name + '|  Parent Name: ' + myrecord.A__r.Name + '| Other Parent Name: ' + myrecord.B__r.Name);
        }
    }
/*
RelationshipQueries obj = new RelationshipQueries();
obj.AllCRecordsWithParentDetails();
*/
    public void accountOfContactJohn(){
        List<Account> accList = [
        SELECT Id, Name,
            (SELECT Id, Name FROM Contacts WHERE Name LIKE '%John%') //Retrieving Child Records with the help of child reltioonship name.
        FROM Account
        WHERE Id IN (
            SELECT AccountId FROM Contact WHERE Name LIKE '%John%')]; //Retrieving the Single record from contacts based on the criteria.
        for(Account acc : accList){
            System.debug('Account: ' + acc.Name);
            for(Contact con : acc.Contacts){
                System.debug('Contact: ' + con.Name);
                }
        }
    }
/*
RelationshipQueries obj = new RelationshipQueries();
obj.AccountOfContactJohn();
*/
    public void accountsWithClosedWonOpportunities() {
        List<Account> accounts = [
            SELECT Id, Name , 
            (SELECT Name, StageName FROM Opportunities WHERE IsClosed = True AND IsWon = True)
            FROM Account
            WHERE Id IN 
            (SELECT AccountId FROM Opportunity WHERE IsClosed = True AND IsWon = True)];
        for (Account acc : accounts) {
            System.debug('Account Name: ' + acc.Name );
            List<Opportunity> opportunities = acc.Opportunities;
            for (Opportunity opp : opportunities) {
                System.debug('  Opportunity Name: ' + opp.Name + ' | Stage: ' + opp.StageName);
            }
        }
    }
/*
RelationshipQueries obj = new RelationshipQueries();
obj.AccountsWithClosedWonOpportunities();
*/
    public void parentsWithChildNamedJohn() {
        List<A__c> parentList = [
            SELECT Id, Name,
                (SELECT Id, Name,B__r.Name FROM C__r WHERE Name LIKE 'John%')
            FROM A__c
            WHERE Id IN (
                SELECT A__c FROM C__c WHERE Name LIKE 'John%'
            )
        ];
        for (A__c parent : parentList) {
            System.debug('Parent Name: ' + parent.Name);
            for (C__c child : parent.C__r) {
                system.debug('Other Parent Name: ' + child.B__r.Name);
                System.debug('Child Name: ' + child.Name);
            }
        }
    }
/*
RelationshipQueries obj = new RelationshipQueries();
obj.ParentsWithChildNamedJohn();
*/
}