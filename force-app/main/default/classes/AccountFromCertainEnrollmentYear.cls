public with sharing class AccountFromCertainEnrollmentYear {
    public accountFromCertainEnrollmentYear() {
        String year2010 = '2010';
        String year2013 = '2013';
        String year2014 = '2014';
        List <Account> acclist2010 = [SELECT Name, Id, Enrollment_Year__C 
        FROM Account 
        WHERE Enrollment_Year__C = :year2010]; //(:year2010)];
        for(Account a : acclist2010){
         system.debug(a.Name +' ' +'Enrollment Year for 2010 Year: ' + a.Enrollment_Year__C);
        }
        List <Account> acclist2011 = [SELECT Name, Id, Enrollment_Year__C 
        FROM Account 
        WHERE Enrollment_Year__C = :year2013 AND Enrollment_Year__C = :year2014]; //(:year2013, :year2014)];
        for(Account a : acclist2011){
         system.debug(a.Name +' ' +'Enrollment Year for 2013 And 2014 year: ' + a.Enrollment_Year__C);
        }
        List <Account> acclist = [SELECT Name, Id, Enrollment_Year__C 
        FROM Account 
        WHERE Enrollment_Year__C = :year2010 AND  Enrollment_Year__C != :year2013 AND Enrollment_Year__C != :year2014];
        for(Account a : acclist){
         system.debug(a.Name +' ' +'Enrollment Year for 2010 year but Not 2013 And 2014 year: ' + a.Enrollment_Year__C);
        }
    
    }
}

/*
AccountFromCertainEnrollmentYear obj = new AccountFromCertainEnrollmentYear();
*/
