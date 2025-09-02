trigger EFTTransactionStatusTrigger on EFT_Transaction_Status__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        EFTTransactionStatusHandler.createCasesForDeclinedAVS(Trigger.new);
    }
}