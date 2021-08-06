/**
 * 
 * QuoteLineTriggerHandler class
 *
 *
 *
 * Versioning: 
 *   5/24/2021 : kevinfleck : File Created
 */
public with sharing class QuoteLineTriggerHandler{
    
    public void beforeInsert(){
        
		System.debug('CPQ - QuoteLineTriggerHandler beforeInsert()');
        updateQuoteLines(Trigger.new);
        
    }

    private static void updateQuoteLines(List<SBQQ__QuoteLine__c> quoteLineList){
        List<SBQQ__QuoteLine__c> renewalOrAmendedQuoteLinesToUpdate = new List<SBQQ__QuoteLine__c>();
        Set<Id> quoteIdSet = new Set<Id>(); //  this set holds the Quote IDs associated to this Quote Line

        for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
                quoteIdSet.add(quoteLine.SBQQ__Quote__c);
        }

        Map<Id, SBQQ__Quote__c> quoteFieldMap = new Map<Id, SBQQ__Quote__c>([SELECT Id, SBQQ__Type__c
                                                                             FROM SBQQ__Quote__c
                                                                             WHERE Id IN :quoteIdSet]); // this map holds the related Quote Id as the key and SBQQ__Type__c as the value

        System.debug('quoteFieldMap: ' + quoteFieldMap);

        for(SBQQ__QuoteLine__c quoteLineToUpdate : (List<SBQQ__QuoteLine__c>) Trigger.new){
            System.debug('quoteFieldMap.get(quoteLineToUpdate.SBQQ__Quote__c).SBQQ__Type__c: ' + quoteFieldMap.get(quoteLineToUpdate.SBQQ__Quote__c).SBQQ__Type__c);
            if(quoteFieldMap.get(quoteLineToUpdate.SBQQ__Quote__c).SBQQ__Type__c == 'Renewal' || quoteFieldMap.get(quoteLineToUpdate.SBQQ__Quote__c).SBQQ__Type__c == 'Amendment'){
                renewalOrAmendedQuoteLinesToUpdate.add(quoteLineToUpdate);
            }
        }

        System.debug('renewalOrAmendedQuoteLinesToUpdate.size(): ' + renewalOrAmendedQuoteLinesToUpdate.size());
        System.debug('renewalOrAmendedQuoteLinesToUpdate: ' + renewalOrAmendedQuoteLinesToUpdate);
        
        if(!renewalOrAmendedQuoteLinesToUpdate.isEmpty()){
            getContractLineItemOrAssetValues(renewalOrAmendedQuoteLinesToUpdate);
        }

    }

    private static void getContractLineItemOrAssetValues(List<SBQQ__QuoteLine__c> quoteLineList){

        List<String> originalOrderItemNumberList = new List<String>(); // this list will hold all of the CPQ_Original_OrderItemNumber__c fields potentially involved in this process, this will be used to link Quote Lines to Assets by this field.
        List<SBQQ__QuoteLine__c> onePerUnitList = new List<SBQQ__QuoteLine__c>(); // this list will hold all of the quote lines with related product2 SBQQ__AssetConversion__c field set to 'One per unit'
        List<SBQQ__QuoteLine__c> onePerQuoteLineList = new List<SBQQ__QuoteLine__c>(); // this list will hold all of the quote lines with related product2 SBQQ__AssetConversion__c set to 'One per quote line'
        List<Asset> assetList = new List<Asset>(); // this will hold all of the assets potentially used in this process.
        Map<String, String> originalOrderItemNumberToAssetSerialNumberOnePerUnitMap = new Map<String, String>();
        Map<String, Asset> originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap = new Map<String, Asset>();

        for(SBQQ__QuoteLine__c quoteLine : quoteLineList){
            originalOrderItemNumberList.add(quoteLine.CPQ_Original_OrderItemNumber__c);
            if(quoteLine.SBQQ__Quote__r.SBQQ__Type__c == 'Renewal' && !quoteLine.SBQQ__Product__r.CPQ_Retain_Serial_On_Renewal__c){
                quoteLine.CPQ_Previous_SerialNo__c = '';
            } else {
                assetConverstionTypeSwitch(
                    quoteLine,
                    onePerUnitList,
                    onePerQuoteLineList
                );
            }

            quoteLine.CPQ_NetSuite_SerialNo__c = '';
        }

        getAssets(
            assetList,
            originalOrderItemNumberList,
            originalOrderItemNumberToAssetSerialNumberOnePerUnitMap,
            originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap
            );

        if(!onePerUnitList.isEmpty()){
            setOnePerUnitQuoteLines(onePerUnitList, originalOrderItemNumberToAssetSerialNumberOnePerUnitMap);
        }
        if(!onePerQuoteLineList.isEmpty()){
            setOnePerQuoteLineQuoteLines(onePerQuoteLineList, originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap);
        }

    }

    private static void assetConverstionTypeSwitch(
        SBQQ__QuoteLine__c quoteLine,
        List<SBQQ__QuoteLine__c> onePerUnitList,
        List<SBQQ__QuoteLine__c> onePerQuoteLineList
        ){

        switch on quoteLine.SBQQ__Product__r.SBQQ__AssetConversion__c{
            when 'One per unit' {
                onePerUnitList.add(quoteLine);
            }
            when 'One per quote line' {
                onePerQuoteLineList.add(quoteLine); 
            }
            when null {
                quoteLine.CPQ_Previous_SerialNo__c = quoteLine.CPQ_NetSuite_SerialNo__c;
            }
        }

    }

    private static void getAssets(        
        List<Asset> assetList,
        List<String> originalOrderItemNumberList,
        Map<String, String> originalOrderItemNumberToAssetSerialNumberOnePerUnitMap,
        Map<String, Asset> originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap){

        assetList = [SELECT Id, CPQ_Original_OrderItemNumber__c, SerialNumber, UsageEndDate, CreatedDate
                     FROM Asset
                     WHERE CPQ_Original_OrderItemNumber__c IN :originalOrderItemNumberList];

        for(Asset asset : assetList){
            if(asset.UsageEndDate == null){
                originalOrderItemNumberToAssetSerialNumberOnePerUnitMap.put(asset.CPQ_Original_OrderItemNumber__c, asset.SerialNumber);
            } else {
                originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap.put(asset.CPQ_Original_OrderItemNumber__c, asset);
            }
        }
        System.debug('originalOrderItemNumberToAssetSerialNumberOnePerUnitMap: ' + originalOrderItemNumberToAssetSerialNumberOnePerUnitMap);
        System.debug('originalOrderItemNumberToAssetSerialNumberOnePerUnitMap.size(): ' + originalOrderItemNumberToAssetSerialNumberOnePerUnitMap.size());
        System.debug('originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap: ' + originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap);
        System.debug('originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap.size(): ' + originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap.size());
        
    }

    private static void setOnePerUnitQuoteLines(
        List<SBQQ__QuoteLine__c> onePerUnitList,
        Map<String, String> originalOrderItemNumberToAssetSerialNumberOnePerUnitMap){

        System.debug('one per unit quote line list');
        /*
        TODO:
        query for assets with usage end date = null
        && CPQ_Original_OrderItemNumber__c = CPQ_Original_OrderItemNumber__c of this quote line
        then add as long text area with ; delimited values to CPQ_Previous_SerialNo__c on Quote Line.
        */

        for(SBQQ__QuoteLine__c quoteLine : onePerUnitList){
            quoteLine.CPQ_Previous_SerialNo__c = serialNumberJoin(quoteLine.CPQ_Original_OrderItemNumber__c, originalOrderItemNumberToAssetSerialNumberOnePerUnitMap);
        }

    }

    private static void setOnePerQuoteLineQuoteLines(
        List<SBQQ__QuoteLine__c> onePerQuoteLineList,
        Map<String, Asset> originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap){

        System.debug('one per quote line list');
        /*
        TODO:
        query for assets with CPQ_Original_OrderItemNumber__c = CPQ_Original_OrderItemNumber__c of this quote line
        then choose the asset with the latest created date and set CPQ_Previous_SerialNo__c to the serial
        number field from that asset.
        */

        for(SBQQ__QuoteLine__c quoteLine : onePerQuoteLineList){
            quoteLine.CPQ_Previous_SerialNo__c = getMostRecentAssetSerialNumber(quoteLine.CPQ_Original_OrderItemNumber__c, originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap);
        }

    }

    private static String serialNumberJoin(String originalOrderItemNumber, Map<String, String> originalOrderItemNumberToAssetSerialNumberOnePerUnitMap){

        List<String> serialNumbers;
        for(String key : originalOrderItemNumberToAssetSerialNumberOnePerUnitMap.keySet()){
            serialNumbers.add(originalOrderItemNumberToAssetSerialNumberOnePerUnitMap.get(originalOrderItemNumber));
        }
        System.debug('serialNumbers.join in serialNumberJoin: ' + String.join(serialNumbers, ';'));
        return String.join(serialNumbers, ';');

    }

    private static String getMostRecentAssetSerialNumber(String originalOrderItemNumber, Map<String, Asset>originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap){

        List<Asset> assetToSortList = new List<Asset>();
        List<DateTime> assetDateToSortList = new List<DateTime>();
        Map<DateTime, String> assetToSortByCreatedDateMap;
        for(String key : originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap.keySet()){
            assetToSortList.add(originalOrderItemNumberToAssetSerialNumberOnePerQuoteLineMap.get(originalOrderItemNumber));
        }
        System.debug('assetToSortList: ' + assetToSortList);
        System.debug('assetToSortList.size(): ' + assetToSortList.size());
        for(Asset asset : assetToSortList){
            assetDateToSortList.add(asset.CreatedDate);
            assetToSortByCreatedDateMap.put(asset.CreatedDate, asset.SerialNumber);
        }
        System.debug('assetDateToSortList before sort: ' + assetDateToSortList);
        assetDateToSortList.sort();
        System.debug('assetDateToSortList after sort: ' + assetDateToSortList);
        if(!assetDateToSortList.isEmpty()){
            return assetToSortByCreatedDateMap.get(assetDateToSortList[0]); 
        } else {
            return null;
        }
        

    }

}