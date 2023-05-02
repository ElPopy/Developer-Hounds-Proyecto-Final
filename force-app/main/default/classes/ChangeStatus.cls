public with sharing class ChangeStatus implements Schedulable{
    public void execute(SchedulableContext SC) {

        ChangeStatusProject();
 
     }


    public static void ChangeStatusProject(){
        List<Project__c> projectList = [SELECT Id, Status__c, Sold_Hours__c, Squad_Lead__c, Revenue__c, Estimated_Cost__c,AssignedTotalHours__c FROM Project__c WHERE Status__c = 'Pre-kickoff' AND Start_Date__c = TODAY];
        for(Project__c project : projectList){


            if(project.AssignedTotalHours__c >= project.Sold_Hours__c && project.Squad_Lead__c != null && project.Revenue__c > project.Estimated_Cost__c)
            {
                project.Status__c = 'In progress';
            }
           
        }
        update projectList;
    }







}

