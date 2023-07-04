public with sharing class ChangeStatus implements Schedulable{
    public void execute(SchedulableContext SC) {

        ChangeStatusProject();
        SendEmail();
        ChangeStatusCompleted(); 
 
     }


    public static void ChangeStatusProject(){
        List<Project__c> projectList = [SELECT Id,Squad_Lead__r.FirstName, Status__c, Project_Manager__r.Email,Sold_Hours__c, Squad_Lead__c, Revenue__c, Estimated_Cost__c,AssignedTotalHours__c FROM Project__c WHERE Status__c = 'Pre-kickoff' AND Start_Date__c = TODAY];
        for(Project__c project : projectList){

           

            if(/*project.AssignedTotalHours__c >= project.Sold_Hours__c && */project.Squad_Lead__c != null && project.Revenue__c > project.Estimated_Cost__c)
            {
                project.Status__c = 'In progress';
            }

         
}


                      
        
        update projectList;
    }


public static void ChangeStatusCompleted(){
    List<Project__c> projectList = [SELECT Id, Status__c , End_Date__c FROM Project__c WHERE Status__c = 'In progress'];
    for(Project__c project : projectList){
        if(project.End_Date__c==System.today()){
            project.Status__c = 'Completed';
        }
    }
    update projectList;
}





    
public static void SendEmail(){
    List<Project__c> projectList = [SELECT Id,Name,Squad_Lead__r.FirstName, Status__c, Project_Manager__r.Email,Sold_Hours__c, Squad_Lead__c, Revenue__c, Estimated_Cost__c,AssignedTotalHours__c FROM Project__c WHERE Status__c = 'Pre-kickoff' AND Start_Date__c = TODAY];
    for(Project__c project : projectList){

       

        if(project.Squad_Lead__c == null || project.Revenue__c < project.Estimated_Cost__c)
        {
       
            // The project status did not change, send an email to the Project Manager
            
                // Get the Project Manager's email
                String projectManagerEmail = project.Project_Manager__r.Email;
                // Create the email message
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{projectManagerEmail});
                mail.setSubject('Project status not changed');
                mail.setPlainTextBody('The status of project '+ project.Name +' did not change from "Pre-kickoff".');
                // Send the email
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
            }
     
}
}


                  
    

}