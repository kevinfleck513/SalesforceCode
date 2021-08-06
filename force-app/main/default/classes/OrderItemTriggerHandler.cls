public with sharing class OrderItemTriggerHandler extends TriggerHandler {

    // public OrderItemTriggerHandler() {
    //     super('OrderItemTriggerHandler');
    // }
    
    protected override void beforeInsert() {

        setLineItemId(Trigger.new);

    }

    protected override void afterInsert(){

        System.debug('OrderItemTriggerHandler after insert');
        // setOriginalOrderItemNumber(Trigger.new);

    }

    void setLineItemId(List<OrderItem> orderItems){

        Set<Id> quoteLineIdSet = new Set<Id>();
                

        for(OrderItem orderItem : orderItems){
            quoteLineIdSet.add(orderItem.SBQQ__QuoteLine__c);
        }

        Map<Id, SBQQ__QuoteLine__c> quoteLineMap = new Map<Id, SBQQ__QuoteLine__c>([SELECT Id, Matching_ID__c
                                                                                    FROM SBQQ__QuoteLine__c
                                                                                    WHERE Id IN :quoteLineIdSet]);

        for(OrderItem orderItem : orderItems){
            if(String.isBlank(quoteLineMap.get(orderItem.SBQQ__QuoteLine__c).Matching_ID__c)){
                orderItem.Matching_ID__c = String.valueOf(orderItem.SBQQ__QuoteLine__c);
            } else {    
                orderItem.Matching_ID__c = quoteLineMap.get(orderItem.SBQQ__QuoteLine__c).Matching_ID__c;    
            }

        }        

        updateQuoteLineValue(quoteLineIDSet);

    }

    private static void updateQuoteLineValue(Set<Id> quoteLineIdSet){ 
        
        List<SBQQ__QuoteLine__c> quoteLinesToUpdateList = new List<SBQQ__QuoteLine__c>([SELECT Id, Matching_ID__c
                                                                                       FROM SBQQ__QuoteLine__c
                                                                                       WHERE Id IN :quoteLineIdSet]);

        for(SBQQ__QuoteLine__c quoteLineToUpdate : quoteLinesToUpdateList){
            if(String.isBlank(quoteLineToUpdate.Matching_ID__c)){
                quoteLineToUpdate.Matching_ID__c = quoteLineToUpdate.Id; 
            }            

        }

        if(!quoteLinesToUpdateList.isEmpty()) {
            SBQQ.TriggerControl.disable();
            List<Database.SaveResult> saveResults = Database.update(quoteLinesToUpdateList, false);
            SBQQ.TriggerControl.enable();

            for(Database.SaveResult saveResult: saveResults) {
                if (saveResult.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    //System.debug('OrderItemTriggerHandler.updateQuoteLineValue() Successfully updated quote line. QuoteLinieId: ' + saveResult.getId());
                } else {
                    // Operation failed, so get all errors
                    for (Database.Error err : saveResult.getErrors()) {
                        //newBatchJobLog.addError(err.fields.toString(), err.getMessage());
                        System.debug('OrderItemTriggerHandler.updateQuoteLineValue() The following error has occurred.');
                        System.debug('OrderItemTriggerHandler.updateQuoteLineValue()' + err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('OrderItemTriggerHandler.updateQuoteLineValue() Quote line fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }

    }

    private static void setOriginalOrderItemNumber(List<OrderItem> orderItemList){

        for(OrderItem orderItem : orderItemList){
            orderItem.CPQ_Original_OrderItemNumber__c = orderItem.Id;
        }

        update orderItemList;

    }

}