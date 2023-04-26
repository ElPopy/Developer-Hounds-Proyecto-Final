public with sharing class ResourceWrapper {
  public Id id;
  public String firstName;
  public String lastName;
  public Decimal rateHour;
  public Id roleId;

  public ResourceWrapper(User resource) {
    this.id = resource.Id;
    this.firstName = resource.FirstName;
    this.lastName = resource.LastName;
    this.rateHour = resource.Rate_Hour__c;
    this.roleId = resource.UserRoleId;
  }
}