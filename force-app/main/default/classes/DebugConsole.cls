public with sharing class DebugConsole {
  public static void debugConsole() {
    List<Project__c> projects = [SELECT Id FROM Project__c];
    Id projectId = projects.get(0).Id;
    String allocation = '{"a02Dp000001dAUoIAM":[{"resourceId":"005Dp0000027mAVIAY","startDate":"22/4/23","endDate":"27/4/23"}],"a02Dp000001dAUpIAM":[{"resourceId":"005Dp0000027mALIAY","startDate":"22/4/23","endDate":"27/4/23"}]}';
    System.debug(
      'allocateResourse response' +
      ProjectService.allocateResources(projectId, allocation)
    );
  }
}
