public with sharing class UserTriggerHandler {
    public static salesUserSetup(List<User> newUsers) {
        if(newUsers.FirstName.Startswith('Sales')){
            List<UserRole> role = [SELECT Id, Name FROM UserRole WHERE Name = ' Western Sales Team' LIMIT 1];
            for(User u: newUsers){
                u.UserRoleId = role[0].Id;
            }
        }

        }
}
