public with sharing class PositionWrapper {
  public String positionId;
  public String role;
  public Decimal soldHoursToCover;
  public Decimal assignedHours;
  public List<ResourceWrapper> availableResource = new List<ResourceWrapper>();

  public PositionWrapper(ProjectLineItem__c position) {
    this.positionId = position.Id;
    this.role = position.Rol__c;
    this.soldHoursToCover = position.SodlHoursToCover__c;
    assignedHours = position.AssignedHousxRol__c;
  }
}
