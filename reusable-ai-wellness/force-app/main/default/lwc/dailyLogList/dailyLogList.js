import { LightningElement, wire, track } from 'lwc';
import getDailyLogs from '@salesforce/apex/DailyLogController.getDailyLogs';

const COLUMNS = [
    {label:'Date', fieldName:'Date__c', type:'date'},
    {label:'Meals', fieldName:'Meals__c', type:'text'},
    {label:'Workouts', fieldName:'Workout__c', type:'text'},
    {label:'Sleep Hours', fieldName:'Sleep_Hours__c', type:'number'},
    {label:'Mood', fieldName:'Mood__c', type:'text'}
];

export default class DailyLogList extends LightningElement {
    @track logs;
    columns = COLUMNS;

    @wire(getDailyLogs)
    wiredLogs({error, data}){
        if(data) {
            this.logs = data;
        } else if (error) {
            console.error('Error retrieving logs: ', error);
        }
    }
}