public with sharing class ProjectWrapper {
  public Id projectId;
  public String projectStart;
  public String projectEnd;
  public List<PositionWrapper> projectLineItems = new List<PositionWrapper>();

  public ProjectWrapper(Project__c project) {
    this.projectId = project.Id;
    this.projectStart = project.Start_Date__c.format();
    this.projectEnd = project.End_Date__c.format();
    this.configurePositions(project.ProjectLineItems__r);
  }

  private void configurePositions(List<ProjectLineItem__c> positions) {
    for (ProjectLineItem__c position : positions) {
      this.projectLineItems.add(new PositionWrapper(position));
    }
  }
}