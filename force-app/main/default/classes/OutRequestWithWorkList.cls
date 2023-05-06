public with sharing class OutRequestWithWorkList {
  OutRequest request;
  List<ProjectResource> workPeriodList;

  public OutRequestWithWorkList() {
    this.request = new OutRequest();
    this.workPeriodList = new List<ProjectResource>();
  }

  public OutRequestWithWorkList(
    Out_office_req__c outRequest,
    List<Project_Resources__c> projectResources
  ) {
    this.request = new OutRequest(outRequest);
    this.workPeriodList = new List<ProjectResource>();
    parseWorkPeriodList(projectResources);
  }

  private void parseWorkPeriodList(
    List<Project_Resources__c> projectResources
  ) {
    for (Project_Resources__c workPeriod : projectResources) {
      this.workPeriodList.add(new ProjectResource(workPeriod));
    }
  }

  public OutRequest getData() {
    return this.request;
  }

  public List<ProjectResource> getWorkPeriodList() {
    return this.workPeriodList;
  }
}
