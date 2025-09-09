public class DuplicateOpportunitiesBatch implements Database.Batchable<SObject>, Database.Stateful {
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
        List<Opportunity> opportunities = [
            SELECT Id, OwnerId, AccountId, Name, Duplicate__c
            FROM Opportunity
            WHERE AccountId IN :acctIds AND Name != null
        ];
        system.debug('opportunities: ' + opportunities);
        Map<String, List<Opportunity>> byName = new Map<String, List<Opportunity>>();
        for (Opportunity o : opportunities) {
            String nm = o.Name;
            if (!byName.containsKey(nm)) {
                byName.put(nm, new List<Opportunity>());
            }
            byName.get(nm).add(o);
        }
        system.debug('byname: '+ byName);
        List<Opportunity> toUpdate = new List<Opportunity>();
        for (String nm : byName.keySet()) {
            List<Opportunity> groupOpp = byName.get(nm);
            system.debug(groupOpp);
            if (groupOpp.size() > 1) {
                system.debug('adfs4444');
                for (Opportunity o : groupOpp) {
                    o.Duplicate__c = true;
                    toUpdate.add(o);
                    system.debug('toupdate: '+ toUpdate);
                    system.debug('o.OwnerId: ' + o.OwnerId);
                    if(ownerDuplicateCount.containsKey(o.OwnerId)) {
                        Integer CurrentCount = ownerDuplicateCount.get(o.OwnerId);
                        ownerDuplicateCount.put(o.OwnerId, CurrentCount + 1);
                    } else{
                        ownerDuplicateCount.put(o.OwnerId, 1);
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
                m.setSubject('Duplicate Opportunities found: ' + ownerDuplicateCount.get(ownerId));
                m.setPlainTextBody('Hello ' + u.Name + ',\n\n' +
                            'We found ' + ownerDuplicateCount.get(ownerId) +
                            ' duplicate Opportunities (same Name within an Account). ' +
                            'They are marked Duplicate__c = true.');
                emails.add(m);
            }
            if (!emails.isEmpty()){
                Messaging.sendEmail(emails);
            }
        }
    }
}