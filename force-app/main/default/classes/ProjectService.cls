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
    Map<Id, String> roleNameById = new Map<Id, String>();
    for (UserRole role : roleList) {
      roleIdByName.put(role.Name, role.Id);
      roleNameById.put(role.Id, role.Name);
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

      Set<Id> roleIds = new Set<Id>();
      for (PositionWrapper position : wrapper.projectLineItems) {
        roleIds.add(roleIdByName.get(position.role));
      }

      List<ResourceWrapper> availableResources = ResourceService.queryAvailableResources(
        project.Start_Date__c,
        project.End_Date__c,
        roleIds
      );

      Map<String, List<ResourceWrapper>> resourcesByRole = new Map<String, List<ResourceWrapper>>();

      for (ResourceWrapper resource : availableResources) {
        String roleName = roleNameById.get(resource.Id);
        if (resourcesByRole.containsKey(roleName)) {
          resourcesByRole.get(roleName).add(resource);
        } else {
          resourcesByRole.put(roleName, new List<ResourceWrapper>{ resource });
        }
      }

      for (PositionWrapper position : wrapper.projectLineItems) {
        if (resourcesByRole.containsKey(position.role)) {
          position.availableResource = resourcesByRole.get(position.role);
        }
      }

      return JSON.serialize(wrapper);
    } catch (Exception e) {
      System.debug('ProjectService: ' + e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }
}
