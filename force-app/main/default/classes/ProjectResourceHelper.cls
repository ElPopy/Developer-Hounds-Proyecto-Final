public with sharing class ProjectResourceHelper {
  public static void beforeCreate(
    Boolean isBrforeCreate,
    List<Project_Resources__c> newProjectResources
  ) {
    if (isBrforeCreate) {
      Map<Id, List<Project_Resources__c>> projectResourcesByPositionId = new Map<Id, List<Project_Resources__c>>();

      for (Project_Resources__c projectResource : newProjectResources) {
        Id positionId = projectResource.ProjectLineItem__c;
        if (projectResourcesByPositionId.containsKey(positionId)) {
          projectResourcesByPositionId.get(positionId).add(projectResource);
        } else {
          projectResourcesByPositionId.put(positionId, new List<Project_Resources__c>{projectResource});
        }
      }

      
    }
  }

  public static void beforeUpdate(
    Boolean isBeforeUpdate,
    List<Project_Resources__c> newProjectResources,
    Map<Id, Project_Resources__c> oldProjectResourcesMap
  ) {
    if (isBeforeUpdate) {
    }
  }
}
