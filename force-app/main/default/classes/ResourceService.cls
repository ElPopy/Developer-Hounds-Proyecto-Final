public with sharing class ResourceService {
  public static List<ResourceWrapper> queryAvailableResources(
    Date projectStartDate,
    Date projectEndDate,
    Set<Id> roleIds
  ) {
    Map<Id, ResourceWrapper> availableResources = new Map<Id, ResourceWrapper>();

    List<User> resources = [
      SELECT
        FirstName,
        LastName,
        Rate_Hour__c,
        UserRoleId,
        (
          SELECT Id
          FROM Project_Resources__r
          WHERE
            (Start_Date__c > :projectStartDate
            AND Start_Date__c < :projectEndDate)
            OR (End_Date__c > :projectStartDate
            AND End_Date__c < :projectEndDate)
        )
      FROM User
      WHERE UserRoleId IN :roleIds
    ];

    for (User resource : resources) {
      if (resource.Project_Resources__r.size() == 0) {
        availableResources.put(resource.Id, new ResourceWrapper(resource));
      }
    }

    return availableResources.values();
  }
}