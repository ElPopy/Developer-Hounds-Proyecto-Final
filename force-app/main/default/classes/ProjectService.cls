public with sharing class ProjectService {
  @AuraEnabled(cacheable=true)
  public static String getAllocationData(Id projectId) {
    Set<String> roleNames = new Set<String>{
      RoleName.PROJET_MANAGER,
      RoleName.DEVELOPER,
      RoleName.ARCHITECH,
      RoleName.CONSULTANT
    };
    List<UserRole> roleList = [
      SELECT Id, Name
      FROM UserRole
      WHERE Name IN :roleNames
    ];
    Map<String, Id> roleIdByName = new Map<String, Id>();
    for (UserRole role : roleList) {
      roleIdByName.put(role.Name, role.Id);
    }
    try {
      Project__c project = [
        SELECT
          Start_Date__c,
          End_Date__c,
          (
            SELECT Rol__c, SodlHoursToCover__c
            FROM ProjectLineItems__r
          )
        FROM Project__c
        WHERE Id = :projectId
      ];
      ProjectWrapper wrapper = new ProjectWrapper(project);

      List<Id> roleIds = new List<Id>();
      for (PositionWrapper position : wrapper.projectLineItems) {
        roleIds.add(roleIdByName.get(position.role));
      }

      ResourceService.queryAvailableResources(
        project.Start_Date__c,
        project.End_Date__c,
        roleIds
      );

      return JSON.serialize(wrapper);
    } catch (Exception e) {
      System.debug('ProjectService: ' + e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }
}
