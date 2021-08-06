public with sharing class QuoteTriggerHandler {
    
    public void beforeInsert(){
        System.debug('QuoteTriggerHandler beforeInsert()');
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>([SELECT Id, Test_Twin_Field__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :Trigger.new]);
        System.debug('quoteLineList.size() beforeInsert: ' + quoteLineList.size());
        if(!quoteLineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
                System.debug('quoteLine beforeInsert: ' + quoteLine);
            }
        } else {
            System.debug('no quoteLines in list yet beforeInsert context');
        }        
    }

    public void beforeUpdate(){
        System.debug('QuoteTriggerHandler beforeUpdate()');
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>([SELECT Id, Test_Twin_Field__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :Trigger.new]);
        System.debug('quoteLineList.size() beforeUpdate: ' + quoteLineList.size());
        if(!quoteLineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
                System.debug('quoteLine beforeUpdate: ' + quoteLine);
            }
        } else {
            System.debug('no quoteLines in list yet beforeUpdate context');
        }
    }

    public void afterInsert(){
        System.debug('QuoteTriggerHandler afterInsert()');
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>([SELECT Id, Test_Twin_Field__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :Trigger.new]);
        System.debug('quoteLineList.size() afterInsert: ' + quoteLineList.size());
        if(!quoteLineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
                System.debug('quoteLine afterInsert: ' + quoteLine);
            }
        } else {
            System.debug('no quoteLines in list yet afterInsert context');
        }
    }

    public void afterUpdate(){
        System.debug('QuoteTriggerHandler afterUpdate()');
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>([SELECT Id, Test_Twin_Field__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :Trigger.new]);
        System.debug('quoteLineList.size() afterUpdate: ' + quoteLineList.size());
        if(!quoteLineList.isEmpty()){
            for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
                System.debug('quoteLine afterUpdate: ' + quoteLine);
            }
        } else {
            System.debug('no quoteLines in list yet afterUpdate context');
        }
    }

}