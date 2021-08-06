import { LightningElement, api } from 'lwc';

export default class UserAssignmentCustomLookup extends LightningElement {

    @api recordId;
    @api childObjectApiName = 'OrderItem';
    @api targetFieldApiName = 'User_Assignment__c';
    fieldLabel = 'User';
    @api disabled = false;
    @api value;
    @api required = false;

    handleChange(event) {
        // Creates the event
        console.log('selected user: ' + event.detail.value);
        const selectedEvent = new CustomEvent('valueselected', {
            detail: event.detail.value
        });
        //dispatching the custom event
        this.dispatchEvent(selectedEvent);
    }

    connectedCallback(){
        console.log('connectedCallback()');
        const connectedCallbackEvent = new CustomEvent('connectedCallback');
        this.dispatchEvent(connectedCallbackEvent);
    }

    @api isValid() {
        if (this.required) {
            this.template.querySelector('lightning-input-field').reportValidity();
        }
    }

}