@isTest
public class OpportunityTriggerHandlerTest {
    @isTest
    static void testCheckDescriptionForClosedWon() {
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Closed Won',
            CloseDate = Date.today()
        );
        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Insert should have failed');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Description is required'), 'Error message not found');
        }
        Test.stopTest();
    } 
    @isTest
    static void testUpdateOpportunityProductsWithDiscount() {
        Id standardPbId = Test.getStandardPricebookId();
        Pricebook2 stdPb = new Pricebook2(Id = standardPbId, IsActive = true);
        update stdPb;
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;
        PricebookEntry stdPbe = new PricebookEntry(
            Pricebook2Id = stdPb.Id,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert stdPbe;
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp = new Opportunity(
            Name = 'Discount Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id,
            Pricebook2Id = stdPb.Id,
            Line_Item_Discount__c = 10
        );
        insert opp;
                OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opp.Id,
                PricebookEntryId = stdPbe.Id,   
                Quantity = 10,                  
                UnitPrice = 100                
            );
            insert oli;

        Test.startTest();
        opp = [SELECT Id, Line_Item_Discount__c FROM Opportunity WHERE Id = :opp.Id];
        opp.Line_Item_Discount__c = 50;
        update opp;
        opp.Line_Item_Discount__c = 0;
        try {
            update opp;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Line Item Discount must be between 0 and 100'));
        }
        Test.stopTest();
        OpportunityLineItem updatedOli = [
            SELECT UnitPrice FROM OpportunityLineItem WHERE Id = :oli.Id
        ];
        System.assertEquals(45, updatedOli.UnitPrice, 'Discount not applied correctly');
    }


}
