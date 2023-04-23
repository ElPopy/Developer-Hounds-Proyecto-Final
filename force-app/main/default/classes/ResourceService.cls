public with sharing class ResourceService {
  public static List<ResourceWrapper> queryAvailableResources(
    Date projectStartDate,
    Date projectEndDate
  ) {
    List<ResourceWrapper> availableResources = new List<ResourceWrapper>();

    List<Project_Resources__c> projectResources = [
      SELECT
        Resource__c,
        Resource__r.FirstName,
        Resource__r.LastName,
        Resource__r.Rate_Hour__c,
        Resource__r.UserRoleId
      FROM Project_Resources__c
      WHERE End_Date__c <= :projectStartDate
    ];

    for (Project_Resources__c resource : projectResources) {
      availableResources.add(new ResourceWrapper(resource));
    }

    return availableResources;
  }
}
