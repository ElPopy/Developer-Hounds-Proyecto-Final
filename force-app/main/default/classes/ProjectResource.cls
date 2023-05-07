public with sharing class ProjectResource {
  private String resourceId;
  private String projectId;
  private Date startDate;
  private Date endDate;

  public ProjectResource() {
  }

  public ProjectResource(Project_Resources__c workPeriod) {
    this.resourceId = workPeriod.Resource__c;
    this.projectId = workPeriod.Project__c;
    this.startDate = workPeriod.Start_Date__c;
    this.endDate = workPeriod.End_Date__c;
  }

  public DateRange getDateRange() {
    return new DateRange(this.startDate, this.endDate);
  }

  public String getResourceId() {
    return resourceId;
  }

  public void setResourceId(String resourceId) {
    this.resourceId = resourceId;
  }

  public String getProjectId() {
    return projectId;
  }

  public void setProjectId(String projectId) {
    this.projectId = projectId;
  }

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }
}
