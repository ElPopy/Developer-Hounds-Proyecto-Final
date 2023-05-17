public with sharing class DebugConsole {
  public static void debugConsole() {
    List<Project__c> projects = [SELECT Id FROM Project__c];
    Id projectId = projects.get(0).Id;
    String allocation = '{"a02Dp000001dAUoIAM":[{"resourceId":"005Dp0000027mAVIAY","startDate":"4/22/23","endDate":"4/28/23"}],"a02Dp000001dAUpIAM":[{"resourceId":"005Dp0000027mALIAY","startDate":"4/15/23","endDate":"4/30/23"}], "a02Dp000001dAUwIAM":[]}';
    System.debug(
      '>>>>>>>>>>>>allocateResourse response' +
      ProjectService.allocateResources(projectId, allocation)
    );

    // schedule classes
    ChangeStatus.ChangeStatusProject();
    ChangeStatus.SendEmail();
    ChangeStatus.ChangeStatusCompleted();

    // delete all ProjectResourses
    List<Project_Resources__c> prs = [SELECT Id FROM Project_Resources__c];
    delete prs;
    // clear assigned hours
    List<ProjectLineItem__c> plis = [
      SELECT Id, AssignedHousxRol__c
      FROM ProjectLineItem__c
    ];
    for (ProjectLineItem__c item : plis) {
      item.AssignedHousxRol__c = 0.0;
      item.Estimated_Cost__c = 0.0;
    }
    update plis;
    // delete all OutOfOfficeRequest
    List<Out_office_req__c> outReq = [SELECT Id FROM Out_office_req__c];
    delete outReq;

    // debug days between
    System.debug(
      'daysBetween' +
      Date.newInstance(2023, 5, 9).daysBetween(Date.newInstance(2023, 5, 11))
    );
    System.debug('May 9' + Date.newInstance(2023, 5, 9).format());

    // set rate per hour to Resourses
    Set<String> roleNames = new Set<String>{
      RoleName.PROJET_MANAGER,
      RoleName.DEVELOPER,
      RoleName.ARCHITECH,
      RoleName.CONSULTANT
    };
    List<UserRole> roleList = [
      SELECT Id, Name
      FROM UserRole
      WHERE Name IN :roleNames
    ];
    List<User> resources = [
      SELECT Rate_Hour__c
      FROM User
      WHERE UserRoleId IN :roleList
    ];
    Decimal rateHour = 5;
    for (User resource : resources) {
      resource.Rate_Hour__c = rateHour;
      rateHour++;
    }
    update resources;
  }
}

