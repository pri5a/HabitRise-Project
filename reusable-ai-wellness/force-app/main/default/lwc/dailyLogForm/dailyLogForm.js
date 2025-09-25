import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

import DAILY_LOG_OBJECT from '@salesforce/schema/Daily_Log__c';
export default class DailyLogForm extends LightningElement {
    @track formData = {};

    handleChange(event){
        const field = event.target.dataset.field;
        this.formData[field] = event.target.value;
    }

    handleSave(){
        const fields = this.formData;
        const recordInput = {
            apiName: DAILY_LOG_OBJECT.objectApiName,
            fields
        };

        createRecord(recordInput)
            .then(()=>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title:'Success',
                        message:'Daily Log Saved',
                        variant:'success'
                    })
                );
                this.formData = {};
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                    title:'Error',
                    message:error.body.message,
                    variant:'error'
                })
            );
            });
    }
}