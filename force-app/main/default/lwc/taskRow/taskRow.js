import { LightningElement,api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Project_Task__c.Id'
import STATUS_FIELD from '@salesforce/schema/Project_Task__c.Status__c';
import REGISTEREDHOURS_FIELD from '@salesforce/schema/Project_Task__c.Registered_Hours__c';

export default class TaskRow extends LightningElement {

    @api task;
    hours;
    taskTrack;

    @track taskStatus;

    @api
    get taskStarted(){
        if(this.task.Status__c === 'In Progress')
        {
            return true;
        }
        else
        {
            return false;
        }
    }




    handleHours(event){

        this.hours = event.target.value;
        /*  console.log(event.target.dataset) */

    }

    handleIniButton(){

        
        this.taskStatus = true;

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.task.Id;
        fields[STATUS_FIELD.fieldApiName] = 'In Progress';

        updateRecord({fields})
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Tarea Comenzada',
                           
                            variant: 'success'
                        })
                    );
                    this.dispatchEvent(new CustomEvent('refresh', {
                        detail:{
                            refresh: true
                        }
                    }))
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error al iniciar la tarea',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });


       

    }


    handleRegButton(){
    

    const fields = {};
    fields[ID_FIELD.fieldApiName] = this.task.Id;
    console.log(JSON.stringify(fields[ID_FIELD.fieldApiName]))

    fields[REGISTEREDHOURS_FIELD.fieldApiName] = parseInt(this.task[REGISTEREDHOURS_FIELD.fieldApiName]) + parseInt(this.hours);

    console.log(JSON.stringify(fields[REGISTEREDHOURS_FIELD.fieldApiName]));

   //  const recordInput = {fields} 

    updateRecord({fields})
    .then(() => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Hours loaded',
                //message: 'Task updated',
                variant: 'success'
            })
        );
         this.dispatchEvent(new CustomEvent('refresh', {
            detail:{
                refresh: true
            }
        }))
     this.template.querySelector('lightning-input').value = null; 
    })
    .catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error completing task',
                message: 'Las horas ya estan cubiertas o se estan registrando mas horas de las estimadas',
                variant: 'error'
            })
        );
    });
    
                             }
 
    handleComButton(){

        
       /* this.taskTrack = {Name:this.task.Name, Hours:this.hours, ID:this.task.Id}
        console.log(this.taskTrack)*/

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.task.Id;
       
        fields[STATUS_FIELD.fieldApiName] = 'Completed';


        updateRecord({fields})
    .then(() => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Tarea completada',
                //message: 'Task updated',
                variant: 'success'
            })
        );
         this.dispatchEvent(new CustomEvent('refresh', {
            detail:{
                refresh: true
            }
        }))
        this.template.querySelector('lightning-input').value = null; 
    })
    .catch(error => {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error completing task',
                message: 'Las horas ya estan cubiertas o se estan registrando mas horas de las estimadas',
                variant: 'error'
            })
        );
    });



    }

}





/* handleSubmit() {
    
    console.log('boton');

    const taskTrack = { Id: this.task.Id, Registered_Hours__c: this.hours };

    setTareasHoras( {  strJSON : JSON.stringify(taskTrack) } )
    .then((data)=>{

        const event = new ShowToastEvent({

            title: 'Success',
            message: ``,
            variant: 'success'
        });
        this.dispatchEvent(event);

        refresh;

    })

    .catch((error)=>{

        const event = new ShowToastEvent({

            title: `Error`,
            message: error.body.pageErrors[0].message,
            variant: 'error'
        });
        this.dispatchEvent(event);
    });

} */