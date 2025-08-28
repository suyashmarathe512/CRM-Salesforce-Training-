public with sharing class AllActiveUsers {
    public allActiveUsers() {
        Map<Id, User> mymap = new Map<Id, User>([
            SELECT Id, Name, Username 
            FROM User 
            WHERE IsActive = TRUE
        ]);
        Map<String, String> usernameusermap = new Map<String, String>();
        for(User u : mymap.values()){
            usernameusermap.put(u.Username, u.Name);
        }
        for(String username : usernameusermap.keySet()){
            System.debug('User: '+ username + '=> Name: ' + usernameusermap.get(username));
        }
        for(Id recordId : mymap.keySet()){
           // System.debug(recordId + ' ' + mymap.get(recordId).Name);
        }
    }
}

/*
AllActiveUsers obj = new AllActiveUsers();
*/