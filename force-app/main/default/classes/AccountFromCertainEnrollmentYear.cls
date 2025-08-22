public with sharing class AccountFromCertainEnrollmentYear {
    public AccountFromCertainEnrollmentYear() {
        list <Account> acclist2010 = [SELECT Name, Id, Enrollment_Year__C FROM Account WHERE Enrollment_Year__C Includes ('2010')];
        for(Account a : acclist2010){
         system.debug(a.Name +' ' +'Enrollment Year: ' + a.Enrollment_Year__C);
        }
        
        list <Account> acclist2011 = [SELECT Name, Id, Enrollment_Year__C FROM Account WHERE Enrollment_Year__C Includes ('2013', '2014')];
        for(Account a : acclist2011){
         system.debug(a.Name +' ' +'Enrollment Year: ' + a.Enrollment_Year__C);
        }
    }
}

/*
AccountFromCertainEnrollmentYear obj = new AccountFromCertainEnrollmentYear();
*/