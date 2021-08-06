import { LightningElement, api } from 'lwc';
import getQuoteLines from '@salesforce/apex/LWCQuickActionController.getQuoteLines';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuickActionHeadless extends LightningElement {

    @api recordId;

    @api invoke(){
        console.log('headless quick action LWC');
        getQuoteLines({ quoteId: this.recordId })
        .then(result =>{
            console.log('result: ' + JSON.stringify(result));
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