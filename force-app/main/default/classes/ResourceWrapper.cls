public with sharing class ResourceWrapper {
  public Id id;
  public String firstName;
  public String lastName;
  public Decimal rateHour;
  public Id roleId;

  public ResourceWrapper(Project_Resources__c projectResource) {
    this.id = projectResource.Resource__c;
    this.firstName = projectResource.Resource__r.FirstName;
    this.lastName = projectResource.Resource__r.LastName;
    this.rateHour = projectResource.Resource__r.Rate_Hour__c;
    this.roleId = projectResource.Resource__r.UserRoleId;
  }
}
