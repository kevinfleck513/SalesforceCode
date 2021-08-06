trigger QuoteTrigger on SBQQ__Quote__c (before insert, before update, after insert, after update) {

    // if(Trigger.isBefore && Trigger.isInsert){
    //     QuoteTriggerHandler qth = new QuoteTriggerHandler();
    //     qth.beforeInsert();
    //  }
    // if(Trigger.isBefore && Trigger.isUpdate){
    //     QuoteTriggerHandler qth = new QuoteTriggerHandler();
    //     qth.beforeUpdate();
    //  }
    // if(Trigger.isAfter && Trigger.isInsert){
    //     QuoteTriggerHandler qth = new QuoteTriggerHandler();
    //     qth.afterInsert();
    //  }
    // if(Trigger.isAfter && Trigger.isUpdate){
    //     QuoteTriggerHandler qth = new QuoteTriggerHandler();
    //     qth.afterUpdate();
    //  }   

}