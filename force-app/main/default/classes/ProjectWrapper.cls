public with sharing class ProjectWrapper {
  public Id projectId;
  public List<PositionWrapper> projectLineItems = new List<PositionWrapper>();

  public ProjectWrapper(Project__c project) {
    this.projectId = project.Id;
    this.configurePositions(project.ProjectLineItems__r);
  }

  private void configurePositions(List<ProjectLineItem__c> positions) {
    for (ProjectLineItem__c position : positions) {
      this.projectLineItems.add(new PositionWrapper(position));
    }
  }
}
