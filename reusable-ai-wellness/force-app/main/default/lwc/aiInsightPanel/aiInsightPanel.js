import { LightningElement, api, wire } from 'lwc';
import getFeedback from '@salesforce/apex/WellnessCoachController.getFeedback';
export default class AiInsightPanel extends LightningElement {
    @api recordId; //to support record pages in future
    feedbackMessage = '';
    moodTip = '';

    @wire(getFeedback, {recordId: '$recordId'})
    wiredFeedback({ data, error}) {
        if(data) {
            this.feedbackMessage = data.message;
            this.moodTip = data.moodTip;
        } else if(error) {
            console.error('Error retrieving feedback: ', error);
            this.feedbackMessage = 'Error loading AI Insights.';
            // this.error = error.body.message;
            // this.feedback = undefined;
        }
    }

}