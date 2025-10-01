import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { createRecord } from 'lightning/uiRecordApi';
import saveDailyLog from '@salesforce/apex/DailyLogController.saveDailyLog';

import DAILY_LOG_OBJECT from '@salesforce/schema/Daily_Log__c';
export default class DailyLogForm extends LightningElement {
    @track formData = {};

    moodOptions = [
        {label: 'Good', value: 'Good'},
        {label: 'Okay', value: 'Okay'},
        {label: 'Low', value: 'Low'}
    ];

    handleChange(event){
        const field = event.target.dataset.field;
        let val = event.target.value;
        if(event.target.type === 'number') {
            val = val !== '' ? Number(val) : null;
        }
        //this.formData[field] = event.target.value;
        this.formData[field] = val;
    }

    handleSave(){
        //Basic client-side validation
        if(!this.formData['Date__c']) {
            this.showToast('Error', 'Please enter a date.', 'error');
            return;
        }

        const payload = { ...this.formData };
        //Ensure date is yyyy-MM-dd (date input provides this format)
        if(payload.Date__c && payload.Date__c .indexOf('T') !== -1){
            //just in case, trim time part if present
            payload.Date__c = payload.Date__c.split('T')[0];
        }

        saveDailyLog({ jsonData: JSON.stringify(payload)})
        .then(res => {
            if(res && res.success) {
                this.showToast('Saved', 'Daily log saved successfully', 'success');
                //clear inputs
                this.template.querySelectorAll('lightning-input, lightning-textarea, lightning-combobox').forEach(el => {
                    if(el.type === 'number') el.value = null;
                    else el.value = '';
                });
                this.formData = {};
            } else {
                const msg = res && res.error ? res.error : 'Unknown error saving data';
                this.showToast('Error', msg, 'error');
            }
        })
        .catch(error => {
            const message = (error && error.body && error.body.message) ? error.body.message : error.message;
            this.showToast('Error', message, 'error');
        });

        // const fields = this.formData;
        // const recordInput = {
        //     apiName: DAILY_LOG_OBJECT.objectApiName,
        //     fields
        // };

        // createRecord(recordInput)
        //     .then(()=>{
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //                 title:'Success',
        //                 message:'Daily Log Saved',
        //                 variant:'success'
        //             })
        //         );
        //         this.formData = {};
        //     })
        //     .catch(error => {
        //         this.dispatchEvent(
        //             new ShowToastEvent({
        //             title:'Error',
        //             message:error.body.message,
        //             variant:'error'
        //         })
        //     );
        //     });
    }

    showToast(title, message, variant){
        this.dispatchEvent(new ShowToastEvent({ title, message, variant}));
    }
}