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
        String roleName = roleNameById.get(resource.roleId);
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
      throw new AuraHandledException(e.getMessage());
    }
  }

  @AuraEnabled(cacheable=false)
  public static String allocateResources(Id projectId, String allocationData) {
    List<Project_Resources__c> projectResorces = new List<Project_Resources__c>();

    Map<Id, List<Map<String, String>>> allocationsBypositionId = parseAllocationData(
      allocationData
    );

    for (Id positionId : allocationsBypositionId.keySet()) {
      List<Map<String, String>> allocations = allocationsBypositionId.get(
        positionId
      );
      for (Map<String, String> allocation : allocations) {
        projectResorces.add(
          createProjectResource(projectId, positionId, allocation)
        );
      }
    }

    Database.insert(projectResorces);

    return JSON.serialize(projectResorces);
  }

  public static Project_Resources__c createProjectResource(
    Id projectId,
    Id positionId,
    Map<String, String> allocation
  ) {
    Project_Resources__c newProjectResource = new Project_Resources__c(
      Resource__c = (Id) allocation.get('resourceId'),
      Project__c = projectId,
      ProjectLineItem__c = positionId
    );

    Date startDate = Date.parse(allocation.get('startDate'));
    Date endDate = Date.parse(allocation.get('endDate'));

    newProjectResource.Start_Date__c = startDate;
    newProjectResource.End_Date__c = endDate;

    return newProjectResource;
  }

  public static Map<Id, List<Map<String, String>>> parseAllocationData(
    String allocationData
  ) {
    return (Map<Id, List<Map<String, String>>>) JSON.deserializeStrict(
      allocationData,
      Map<Id, List<Map<String, String>>>.class
    );
  }
}
