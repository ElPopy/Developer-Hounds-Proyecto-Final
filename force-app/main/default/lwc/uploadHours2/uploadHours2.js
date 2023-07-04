/*
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getProjectTasksByUser from '@salesforce/apex/ProjectTaskController.getProjectTasksByUser';
import changeStatus from '@salesforce/apex/ProjectTaskController.changeStatus';
import registerHours from '@salesforce/apex/ProjectTaskController.registerHours';
import uId from '@salesforce/user/Id';

import { LightningElement, api, wire } from 'lwc';
import getProjectTasks from '@salesforce/apex/ProjectTaskController.getProjectTasks';


const columns = [
    { label: 'Task', fieldName: 'Name', editable: false },
    { label: 'State', fieldName: 'Status__c', editable: false },
    { label: 'Estimated Hours', fieldName: 'Estimated_Hour__c', editable: false },
    { label: 'Registered Hours', fieldName: 'Registered_Hours__c', editable: false},
    { label: 'Hours', fieldName: 'Hours', editable: true},
    { type: "button", typeAttributes: {
        label: 'Register Hours',
        name: 'addHours',
        title: 'Edit',
        disabled: false,
        value: 'edit',
        iconPosition: 'left',
        variant: 'brand-outline',
    } },
    { type: "button", typeAttributes: {
        label: 'Complete Task',
        name: 'complete',
        title: 'Edit',
        disabled: false,
        value: 'edit',
        iconPosition: 'left',
        variant: 'brand-outline',
       
    } },
    { 
        type: "button", 
        typeAttributes: { 
            label: 'Start Task', 
            name: 'start', 
            title: 'Edit', 
            disabled: false, 
            value: 'edit', 
            iconPosition: 'left', 
            variant: 'brand', 
        } 
    }
    
];

export default class ProjectTasks extends LightningElement {
    //task={};
    projectData;
    columns = columns;
    wireResult;


    @api
    async refresh() {
        await refreshApex(this.wiredTasks);
    }

    @wire(getProjectTasks)
    wiredTasks(Result) {
        const { data, error } = Result;
        this.wireResult = Result;
        if (data) {
            let projectMap = new Map();
            data.forEach(task => {
                if (task.Project__c) {
                    let project = projectMap.get(task.Project__c);
                    if (!project) {
                        project = {
                            projectName: task.Project__r.Name,
                            numTasks: 0,
                            tasks: []
                        };
                    }
                   
                    project.tasks.push(task);
                    project.numTasks++;
                    projectMap.set(task.Project__c, project);
                }
            });
            this.projectData = Array.from(projectMap.values());
        } else if (error) {
            console.error(error);
        }
    }


    handleMarkCompleted() {
        let tasks = this.template.querySelector('lightning-datatable').getSelectedRows();
        let taskIds = tasks.map(task => task.Id);
        changeStatus({taskIds: taskIds, status: 'Completed'}).then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Tasks marked as completed',
                    variant: 'success'
                })
            );
            return refreshApex(this.wiredTasks);
        }).catch(error => {
            console.error(error);
        });

       
    }


}



*/




import { LightningElement, wire,api } from 'lwc';
import getProjectTasks from '@salesforce/apex/ProjectTaskController.getProjectTasks';
/* import getProjectsAndTasks from '@salesforce/apex/ProjectTaskController.getProjectsAndTasks'; */
import { refreshApex } from '@salesforce/apex';
export default class uploadHours2 extends LightningElement {
   
    projects = [];
    data;
    

   
   

    @wire(getProjectTasks)
    wiredProjectTasks({ error, data })
   {
        this.data=data;
        if (data) {
            // Group tasks by project
            console.log(data)
            const projectsMap = new Map();
            data.forEach(task => {
                const projectId = task.Project__c;
                if (projectsMap.has(projectId)) {
                    const project = projectsMap.get(projectId);
                    project.Tasks.push(task);
                    project.TaskCount++;
                } else {
                    const project = {
                        Id: task.Project__c,
                        Name: task.Project__r.Name,
                        TaskCount: 1,
                        Tasks: [task]
                    };
                    projectsMap.set(projectId, project);
                }
            });

            // Convert map to array and set to projects property
            this.projects = Array.from(projectsMap.values());
        } else if (error) {
            console.error(error);
        }
    }

    

    refresh(){
        return refreshApex(this.data);
    }



}