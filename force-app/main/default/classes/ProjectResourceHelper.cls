public with sharing class ProjectResourceHelper {
  public static void afterCreate(
    Boolean isAfterInsert,
    List<Project_Resources__c> newProjectResources
  ) {
    if (isAfterInsert) {
      Set<Id> positionIds = new Set<Id>();
      
      Map<Id, User> usersById = new Map<Id, User>([SELECT Rate_Hour__c FROM User]);

      Map<Id, Decimal> assignedHoursByPositionId = new Map<Id, Decimal>();
      Map<Id, Decimal> estimatedCostByPositionId = new Map<Id, Decimal>();

      
      for (Project_Resources__c projectResource : newProjectResources) {
        positionIds.add(projectResource.ProjectLineItem__c);
        Decimal rateHour = usersById.get(projectResource.Resource__c).Rate_Hour__c;
        addHours(assignedHoursByPositionId, projectResource);
        addCost(estimatedCostByPositionId, rateHour, projectResource);
      }

      List<ProjectLineItem__c> positions = [
        SELECT AssignedHousxRol__c, Estimated_Cost__c
        FROM ProjectLineItem__c
        WHERE Id IN: positionIds
      ];

      for (ProjectLineItem__c position : positions) {
        Decimal hours = checkNull(position.AssignedHousxRol__c);
        Decimal cost = checkNull(position.Estimated_Cost__c);
        position.AssignedHousxRol__c = hours + assignedHoursByPositionId.get(position.Id);
        position.Estimated_Cost__c = cost + estimatedCostByPositionId.get(position.Id);
      }

      Database.update(positions);

    }
  }

  public static void addHours(Map<Id, Decimal> assignedHoursByPositionId, Project_Resources__c projectResource) {
    Id positionId = projectResource.ProjectLineItem__c;
    Decimal assignedHours = projectResource.Assigned_Hours__c;
    sumValue(assignedHoursByPositionId, positionId, assignedHours);
  }

  public static void addCost(Map<Id, Decimal> estimatedCostByPositionId, Decimal rateHour, Project_Resources__c projectResource) {
    Id positionId = projectResource.ProjectLineItem__c;
    Decimal assignedHours = projectResource.Assigned_Hours__c;
    Decimal cost = assignedHours * rateHour;
    sumValue(estimatedCostByPositionId, positionId, cost);
  }

  public static void sumValue(Map<Id, Decimal> decimalById, Id key, Decimal value) {
    if (decimalById.containsKey(key)) {
      Decimal newValue = decimalById.get(key) + value;
      decimalById.put(key, newValue);
    } else {
      decimalById.put(key, value);
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

  public static Decimal checkNull(Decimal value) {
    if (value == null) {
      return 0.0;
    } else {
      return value;
    }
  }
}