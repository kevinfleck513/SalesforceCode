import { LightningElement, api, track } from 'lwc';
import getQuoteLines from '@salesforce/apex/LWCQuickActionController.getQuoteLines';

export default class QuickActionHeadless extends LightningElement {

    @api recordId;
    @track tableData;

    invoke(){
        console.log('headless quick action LWC');
        getQuoteLines({ quoteId: this.recordId })
        .then(result =>{
            console.log('result: ' + JSON.stringify(result));
            this.tableData = result;
        }).catch(error=>{
            this.showToast(error.name, error.message, 'error');
        })
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }));
    }
}