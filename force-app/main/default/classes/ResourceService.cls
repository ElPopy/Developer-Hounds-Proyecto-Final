public with sharing class ResourceService {

   


public static Map<String, List<User>> getResources(Project__c project) {
  // Obtiene una lista de todos los elementos de línea de proyecto asociados al proyecto dado.
  List<ProjectLineItem__c> projectLineItemList = project.ProjectLineItems__r;

  // Obtiene las fechas de inicio y fin del proyecto del objeto project.
  Date startDate = project.Start_Date__c;
  Date endDate = project.End_Date__c;

  // Realiza una consulta a la base de datos para obtener los recursos que no están asignados
  // a otras tareas durante el período de tiempo del proyecto (startDate y endDate), o que están asignados a otros proyectos
  List<Project_Resources__c> projectResourcesAvailables = [SELECT Id, ProjectLineItem__r.Project__r.Id, Resource__c, Start_Date__c, End_Date__c, Rol__c ,Resource__r.UserRoleId,Resource__r.UserRole.Name FROM Project_Resources__c WHERE ((Start_Date__c < :startDate AND End_Date__c < :startDate) OR (Start_Date__c > :endDate AND End_Date__c > :endDate))];

  // Crea un conjunto de IDs de usuario únicos a partir de la lista de recursos disponibles devueltos por la consulta.
  Set<Id> userIds = new Set<Id>();
  for (Project_Resources__c projectResource : projectResourcesAvailables) {
      userIds.add(projectResource.Resource__c);
  }

  // Realiza una consulta a la base de datos para obtener los nombres de usuario correspondientes a los IDs de usuario en el conjunto.
  Map<Id, User> usersById = new Map<Id, User>([SELECT Id, FirstName,LastName,Name FROM User WHERE Id IN :userIds]);

  // Crea un mapa vacío para almacenar los recursos disponibles por cada rol.
  Map<String, List<User>> resourcesAvailable = new Map<String, List<User>>();

  // Itera sobre los recursos disponibles devueltos por la consulta y los agrupa por rol.
  for (Project_Resources__c projectResource : projectResourcesAvailables) {
      String role = projectResource.Resource__r.UserRole.Name;
      Id userId = projectResource.Resource__c;

      // Si el rol aún no se ha agregado al mapa, crea una lista vacía para el mismo.
      if (!resourcesAvailable.containsKey(role)) {
          resourcesAvailable.put(role, new List<User>());
      }

      // Agrega el usuario a la lista correspondiente al rol en el mapa.
      resourcesAvailable.get(role).add(new User(Id = userId));
  }

  // Itera sobre los recursos disponibles en el mapa y actualiza los IDs de usuario con los nombres de usuario correspondientes.
  for (List<User> userList : resourcesAvailable.values()) {
      for (User user : userList) {
          
          user.FirstName = usersById.get(user.Id).FirstName;
          user.LastName = usersById.get(user.Id).LastName;
      }
  }

  // Devuelve el mapa de recursos disponibles por rol.
  return resourcesAvailable;
}







  @AuraEnabled(cacheable=true)
  public static ResourceWrapper getResourcesWrapper(Id projectId){
       
      Project__c project = [SELECT Id, Start_Date__c,End_Date__c, (SELECT Id,Rol__c FROM ProjectLineItems__r) FROM Project__c WHERE Id=:projectId];
      Map<String, List<User>> resourcesAvailable = getResources(project);
      //  system.debug('Estos son mis recursos: '+resourcesAvailable);
      ResourceWrapper resourceWrap = new ResourceWrapper(project,resourcesAvailable);
      return resourceWrap;
  }



 
    ///////Clase Wrapper/////////////////
    public class ResourceWrapper {
        @AuraEnabled
        public Project__c project;
        @AuraEnabled
        public Map<String, List<User>> resources;
        public ResourceWrapper(Project__c project,Map<String, List<User>> resources){
            this.project =project;
            this.resources = resources;
        }
        
    }































    public static map<String,List<user>> getResources2(Project__c project)
    {
        map <string,List<user>> resourceMap = new map <String,List<user>>();
        Date startDate = project.Start_Date__c;
        Date endDate = project.End_Date__c;
       
      List<Project_Resources__c> projectResourcesAvailables= [select id,Project__c,Resource__c,Start_Date__c,End_Date__c,Rol__c from Project_Resources__c  WHERE ((Start_Date__c <: startDate AND End_Date__c <: startDate)OR(Start_Date__c >: endDate AND End_Date__c >: endDate))];

      // Iterating over project resources and adding them to the map
    for (Project_Resources__c pr : projectResourcesAvailables) {
      User resource = [SELECT Id, Name FROM User WHERE Id = :pr.Resource__c LIMIT 1];

      if (resource != null) {
          String role = pr.Rol__c;

          if (!resourceMap.containsKey(role)) {
              resourceMap.put(role, new List<User>());
          }

          resourceMap.get(role).add(resource);
      }
  }

  return resourceMap;
      
        


    }    




}