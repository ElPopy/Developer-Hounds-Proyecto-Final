import { LightningElement,api } from 'lwc';

export default class TaskRow extends LightningElement {

    @api task;

    @api
    get taskStarted(){
        if (this.task.Status__c === 'In Progress') {
            return true;
        }else {
            return false;
        }
    }

}