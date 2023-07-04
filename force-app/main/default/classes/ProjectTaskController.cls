public with sharing class ProjectTaskController {
    @AuraEnabled(cacheable=true)
    public static List<Project_Task__c> getProjectTasks() {
        return [SELECT Id, Name, Status__c, Estimated_Hour__c, Registered_Hours__c, Project__c, Project__r.Name,
        Project__r.Start_Date__c, Start_Date__c
                FROM Project_Task__c
                WHERE Project_Resource__r.Resource__c =: UserInfo.getUserId() AND Project__c != null AND Status__c != 'Completed' ORDER BY Project__r.Start_Date__c ASC, Status__c DESC, Start_Date__c ASC];
    }


    public class ProjectTaskWrapper{
        @auraEnabled
        public List <Project_Task__c> tasks;

        public ProjectTaskWrapper(List <Project_Task__c> tasks)
        {
            this.tasks = tasks;
        }
    }




    //obtener los project_task__c filtradas por usuario logueado



    @AuraEnabled(cacheable=true)
    public static ProjectTaskWrapper getProjectTasksByUser(Id user) {
        List<Project_Task__c> projectTasks = [SELECT Name, Status__c, Estimated_Hour__c, Registered_Hours__c, Project__c, Project__r.Name,Project_Resource__r.Resource__c
                FROM Project_Task__c
                WHERE Project__c != null AND Project_Resource__r.Resource__c= :user AND Status__c != 'Completed' ORDER BY Status__c DESC];
        return new ProjectTaskWrapper(projectTasks);
       
    }


    //cambiamos el estado de la tarea a completed
    @AuraEnabled
    public static Boolean changeStatus (Id taskId,string state)
    {
        Boolean satatusToUp = false;
        
            Project_Task__c task = [SELECT Id, Status__c FROM Project_Task__c WHERE Id = :taskId];
            task.Status__c = state;
            
            if(task != null)
            {
                update task;
                satatusToUp = true;
            }
            return satatusToUp;
       

    }



    //registramos las horas

    @AuraEnabled
    public static Boolean registerHours (Id taskId,Integer hours)
    {
        Boolean satatusToUp = false;
        
            Project_Task__c task = [SELECT Id, Registered_Hours__c FROM Project_Task__c WHERE Id = :taskId];
            task.Registered_Hours__c +=  hours;
            
            if(task != null)
            {
                update task;
                satatusToUp = true;
            }
            return satatusToUp;
       

    }










}