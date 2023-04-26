public with sharing class DebugConsole {
  public static void debugConsole() {
    List<Project__c> projects = [SELECT Id FROM Project__c];
    Id projectId = projects.get(0).Id;
    String allocation = '{"a02Dp000001dAUoIAM":[{"resourceId":"005Dp0000027mAVIAY","startDate":"4/22/23","endDate":"4/28/23"}],"a02Dp000001dAUpIAM":[{"resourceId":"005Dp0000027mALIAY","startDate":"4/15/23","endDate":"4/30/23"}], "a02Dp000001dAUwIAM":[]}';
    System.debug(
      '>>>>>>>>>>>>allocateResourse response' +
      ProjectService.allocateResources(projectId, allocation)
    );

    // delete all ProjectResourses
    List<Project_Resources__c> prs = [SELECT Id FROM Project_Resources__c];
    delete prs;
    // clear assigned hours
    List<ProjectLineItem__c> plis = [SELECT Id, AssignedHousxRol__c FROM ProjectLineItem__c];
    for (ProjectLineItem__c item : plis) {
      item.AssignedHousxRol__c = 0.0;
    }
    update plis;
  }
}
