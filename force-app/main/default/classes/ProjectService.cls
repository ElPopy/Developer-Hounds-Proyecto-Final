public with sharing class ProjectService {
  static final String START_DATE = 'startDate';
  static final String END_DATE = 'endDate';

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
    Map<Id, Decimal> assignedHoursByPositionId = new Map<Id, Decimal>();

    Project__c project = [
      SELECT Id, Project_Manager__c
      FROM Project__c
      WHERE Id = :projectId
    ];

    Map<Id, List<Map<String, String>>> allocationsByPositionId = parseAllocationData(allocationData);

    for (Id positionId : allocationsByPositionId.keySet()) {
      List<Map<String, String>> allocations = allocationsByPositionId.get(positionId);

      for (Map<String, String> allocation : allocations) {
        Project_Resources__c projectResource = createProjectResource(project, positionId, allocation);
        projectResorces.add(projectResource);
        // better in trigger
        addHours(assignedHoursByPositionId, projectResource);
      }
    }
    
    Database.insert(projectResorces);
    
    // better in trigger
    Set<Id> itemIds = assignedHoursByPositionId.keySet();
    List<ProjectLineItem__c> projectLineItems = [
      SELECT AssignedHousxRol__c 
      FROM ProjectLineItem__c 
      WHERE Id IN :itemIds
    ];      
    
    for (ProjectLineItem__c item : projectLineItems) {
      item.AssignedHousxRol__c += assignedHoursByPositionId.get(item.Id);
    }
    
    Database.update(projectLineItems);
    // better in trigger ends

    return JSON.serialize(projectResorces);
  }

  public static void addHours(Map<Id, Decimal> assignedHoursByPositionId, Project_Resources__c projectResource) {
    Id positionId = projectResource.ProjectLineItem__c;
    Decimal assignedHours = projectResource.Assigned_Hours__c;

    if (assignedHoursByPositionId.containsKey(positionId)) {
      Decimal newHours = assignedHoursByPositionId.get(positionId) + assignedHours;
      assignedHoursByPositionId.put(positionId, newHours);
    } else {
      assignedHoursByPositionId.put(positionId, assignedHours);
    }
  }

  public static Project_Resources__c createProjectResource(Project__c project, Id positionId, Map<String, String> allocation) {
    Project_Resources__c newProjectResource = new Project_Resources__c(
      Resource__c = (Id) allocation.get('resourceId'),
      Project__c = project.Id,
      ProjectLineItem__c = positionId,
      OwnerId = project.Project_Manager__c
    );

    Date startDate = getDate(START_DATE, allocation);
    Date endDate = getDate(END_DATE, allocation);

    newProjectResource.Start_Date__c = startDate;
    newProjectResource.End_Date__c = endDate;

    newProjectResource.Assigned_Hours__c = busnessHours(startDate, endDate);

    return newProjectResource;
  }

  public static Decimal busnessHours(Date startDate, Date endDate) {
    Decimal hoursPerDay = 8;
    return startDate.daysBetween(endDate) * hoursPerDay;
  }

  public static Date getDate(String key, Map<String, String> allocation) {
    return Date.parse(allocation.get(key));
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
