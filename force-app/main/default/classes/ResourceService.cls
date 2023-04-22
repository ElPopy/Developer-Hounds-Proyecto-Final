public with sharing class ResourceService {

    
    public static List<user>getResourceByRol(set<Id> resourceId,String Role) {
     List<user> users = new List<user>();
     users = [select id,Name,UserRoleId,Rate_Hour__c from user where id in :resourceId and UserRoleId =:Role];
     return users;
    }


    private static map<String,List<user>> getResources(Project__c project)
    {
         map <string,List<user>> resourceMap = new map <String,List<user>>();
        Date startDate = project.Start_Date__c;
        Date endDate = project.End_Date__c;

       //List<Project_Resources__c> projectResourcesAvailables = [select id,Project__c,Resource__c,Start_Date__c,End_Date__c from Project_Resources__c  where (startDate > End_Date__c OR endDate < Star_Date__c)  AND Project__c =:project.id];
        //where (startDate > End_Date__c OR endDate <: Star_Date__c) 

        //no disponibles para la fechas del proyecto:
      //  List<Project_Resources__c> projectResourcesAvailables= [select id,Project__c,Resource__c,Start_Date__c,End_Date__c from Project_Resources__c  WHERE NOT (Star_Date__c <: startDate AND End_Date__c <: endDate)];
        Set<Id> resourceNotAvailables = new Set<Id>();
        return resourceMap;
        


    }    




}