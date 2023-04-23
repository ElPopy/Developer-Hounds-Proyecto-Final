public with sharing class ResourceService {
  public static List<ResourceWrapper> queryAvailableResources(
    Date projectStartDate,
    Date projectEndDate
  ) {
    Map<Id, ResourceWrapper> availableResources = new Map<Id, ResourceWrapper>();

    List<Project_Resources__c> projectResources = [
      SELECT
        Resource__c,
        Resource__r.FirstName,
        Resource__r.LastName,
        Resource__r.Rate_Hour__c,
        Resource__r.UserRoleId
      FROM Project_Resources__c
      WHERE End_Date__c <= :projectStartDate OR Start_Date__c >= :projectEndDate
    ];

    for (Project_Resources__c resource : projectResources) {
      if (!availableResources.containsKey(resource.Resource__c)) {
        availableResources.put(
          resource.Resource__c,
          new ResourceWrapper(resource)
        );
      }
    }

    return availableResources.values();
  }
}
