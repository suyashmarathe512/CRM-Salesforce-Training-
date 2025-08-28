public with sharing class SOSLQueries {
    public static List<List<SObject>> findTestInNames() {
        List<List<SObject>> results = [
            FIND 'test' IN NAME FIELDS
            RETURNING
                Contact(Id, FirstName, LastName),
                Account(Id, Name),
                Lead(Id, FirstName, LastName),
                User(Id, FirstName, LastName)
        ];
        for (List<SObject> sObjectList : results) {
            for (SObject record : sObjectList) {
                System.debug(record); 
            }
        }
        return results;
    }
}
/*
List<List<SObject>> searchResults = SOSLQueries.findTestInNames();

*/     

