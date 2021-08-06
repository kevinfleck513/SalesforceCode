import { LightningElement, api, track } from 'lwc';
import getQuoteLines from '@salesforce/apex/LWCQuickActionController.getQuoteLines';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class QuickActionScreen extends LightningElement {

    @api recordId;
    @track quoteLines;

    @api invoke(){
        getQuoteLines({ quoteId: this.recordId })
        .then((result) =>{
            console.log('result: ' + JSON.stringify(result));
            // this.quoteLines = JSON.stringify(result);
            console.log('result after: ' + JSON.stringify(result));
        }).catch(error=>{
            this.showToast(error.name, error.message, 'error');
        })
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title, message, variant
        }));
    }

    closeAction(){
        console.log('close action clicked');
        this.dispatchEvent(new CloseActionScreenEvent());
      }

}