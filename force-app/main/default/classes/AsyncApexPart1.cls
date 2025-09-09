public with sharing class AsyncApexPart1 {
    @future
    public static void insertUserAsync(String username, String email, String lastName, String firstName, String alias, String communityNickname, String profileId) {
        User newUser = new User(
            Username = username,
            Email = email,
            LastName = lastName,
            FirstName = firstName,
            Alias = alias,
            CommunityNickname = communityNickname,
            ProfileId = profileId
        );
        insert newUser;
    }
    public static void solveMixDMLError() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id;
        insertUserAsync('testuser@example.com', 'testuser@example.com', 'Test', 'User', 'tuser', 'testuser', profileId);

        Account newAccount = new Account(Name = 'Test Account');
        insert newAccount;
    }

    // 2) Future method to update Account Description
    @future
    public static void updateAccountDescriptionsAsync() {
        List<Account> accountsToUpdate = [SELECT Id, Description FROM Account];
        for (Account acc : accountsToUpdate) {
            if(acc.Description == null || acc.Description == ''){
                acc.Description = 'Account Description';
            }
        }
        update accountsToUpdate;
    }
}