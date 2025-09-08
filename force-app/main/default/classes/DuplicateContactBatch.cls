public class DuplicateContactBatch implements Database.Batchable<sObject>, Database.Stateful {
    private Map<Id, Integer> ownerDuplicateCount = new Map<Id, Integer>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('Start method');
        return Database.getQueryLocator([SELECT Id FROM Account WHERE IsPersonAccount = false]);
    }
    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        system.debug('Execute method');
        Set<Id> acctIds = new Set<Id>();
        for (Account a : accounts) {
            acctIds.add(a.Id);
        }
        List<Contact> contacts = [
            SELECT Id, OwnerId, AccountId, Name, Duplicate__c
            FROM Contact
            WHERE AccountId IN :acctIds AND Name != null
        ];
        system.debug('contacts: ' + contacts);
        Map<String, List<Contact>> byName = new Map<String, List<Contact>>();
        for (Contact c : contacts) {
            String nm = c.Name;
            if (!byName.containsKey(nm)) {
                byName.put(nm, new List<Contact>());
            }
            byName.get(nm).add(c);
        }
        system.debug('byname: '+ byName);
        List<Contact> toUpdate = new List<Contact>();
        for (String nm : byName.keySet()) {
            List<Contact> groupCon = byName.get(nm);
            system.debug(groupCon);
            if (groupCon.size() > 1) {
                for (Contact c : groupCon) {
                    c.Duplicate__c = true;
                    toUpdate.add(c);
                    system.debug('toupdate: '+ toUpdate);
                    system.debug('c.OwnerId: ' + c.OwnerId);
                    if(ownerDuplicateCount.containsKey(c.OwnerId)) {
                        Integer CurrentCount = ownerDuplicateCount.get(c.OwnerId);
                        ownerDuplicateCount.put(c.OwnerId, CurrentCount + 1);
                    } else{
                        ownerDuplicateCount.put(c.OwnerId, 1);
                    }
                } 
            }
        }
        if (!toUpdate.isEmpty()) 
        {
            update toUpdate;
        }
        system.debug('ownerDuplicateCount: ' + ownerDuplicateCount);
    }
    public void finish(Database.BatchableContext bc) {
        system.debug('Finish method');
        if (!ownerDuplicateCount.isEmpty()){
            Map<Id, User> owners = new Map<Id, User>([SELECT Id, Name, Email 
                FROM User WHERE Id IN :ownerDuplicateCount.keySet()]);
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (Id ownerId : ownerDuplicateCount.keySet()) {
                User u = owners.get(ownerId);
                Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
                m.setToAddresses(new string[] {u.Email});
                m.setSubject('Duplicate Contacts found: ' + ownerDuplicateCount.get(ownerId));
                m.setPlainTextBody('Hello ' + u.Name + ',\n\n' +
                            'We found ' + ownerDuplicateCount.get(ownerId) +
                            'duplicate Contacts (same Name within an Account). ' +
                            'They are marked Duplicate__c = true.');
                emails.add(m);
            }
            if (!emails.isEmpty()){
                Messaging.sendEmail(emails);
            }
        }
    }
}
