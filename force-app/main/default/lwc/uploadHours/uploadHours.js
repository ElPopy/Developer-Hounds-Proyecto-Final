import { LightningElement, wire,api } from 'lwc';
import getProjectTasks from '@salesforce/apex/ProjectTaskController.getProjectTasks';

import { refreshApex } from '@salesforce/apex';
export default class uploadHours2 extends LightningElement {
   
    projects = [];


    refreshData;

    @wire(getProjectTasks)
    wiredProjectTasks(result) {
        this.refreshData = result;
        const { data, error } = result;

        if (data) {
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
            this.projects = Array.from(projectsMap.values());
        } else if (error) {
            console.error(error);
        }
    }

    refresh() {
        return refreshApex(this.refreshData);
    }


}