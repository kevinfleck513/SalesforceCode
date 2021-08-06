trigger QuoteLineTrigger on SBQQ__QuoteLine__c (before insert, before update, after insert, after update) {
    

    // new QuoteLineTriggerHandler().run();
    // Standard way of executing triggers:
    if(Trigger.isBefore && Trigger.isInsert){
        QuoteLineTriggerHandler qlth = new QuoteLineTriggerHandler();
        qlth.beforeInsert();
     }
    // if(Trigger.isBefore && Trigger.isUpdate){
    //     QuoteLineTriggerHandler qlth = new QuoteLineTriggerHandler();
    //     qlth.beforeUpdate();
    //  }
    // if(Trigger.isAfter && Trigger.isInsert){
    //     QuoteLineTriggerHandler qlth = new QuoteLineTriggerHandler();
    //     qlth.afterInsert();
    //  }
    // if(Trigger.isAfter && Trigger.isUpdate){
    //     QuoteLineTriggerHandler qlth = new QuoteLineTriggerHandler();
    //     qlth.afterUpdate();
    //  }   

}