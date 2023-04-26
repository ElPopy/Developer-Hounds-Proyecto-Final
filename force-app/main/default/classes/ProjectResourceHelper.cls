public with sharing class ProjectResourceHelper {
  public static void beforeCreate(
    Boolean isBrforeCreate,
    List<Project_Resources__c> newProjectResources
  ) {
    if (isBrforeCreate) {
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
