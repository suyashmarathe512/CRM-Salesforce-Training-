public with sharing class AllActiveUsers {
    public AllActiveUsers() {
        map<Id, User> mymap = new map<Id, User>([
            SELECT Id, Name, Username 
            FROM User 
            WHERE IsActive = TRUE
        ]);
        
        for(Id recordId : mymap.keyset()){
            System.debug(recordId + ' ' + mymap.get(recordId).Name);
        }
    }
}
/*
AllActiveUsers obj = new AllActiveUsers();
*/