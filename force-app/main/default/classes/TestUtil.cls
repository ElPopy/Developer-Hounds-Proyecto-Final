public with sharing class TestUtil {
  public static void createUsers(List<Map<String, Object>> userDataList) {
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
    Map<String, Id> roleId = new Map<String, Id>();
    for (UserRole role : roleList) {
      roleId.put(role.Name, role.Id);
    }

    List<User> newUsers = new List<User>();

    for (Map<String, Object> userData : userDataList) {
      String firstName = (String) userData.get('FirstName');
      String email = firstName + '@cloudconsulting.com';

      User newUser = new User();

      newUser.FirstName = firstName;
      newUser.LastName = 'Doe';
      newUser.Email = email;
      newUser.Username = email;
      newUser.Alias = 'A' + firstName;
      newUser.CommunityNickname = 'N' + firstName;
      newUser.LocaleSidKey = 'en_US';
      newUser.TimeZoneSidKey = 'America/Los_Angeles';
      newUser.EmailEncodingKey = 'UTF-8';
      newUser.LanguageLocaleKey = 'en_US';
      newUser.Rate_Hour__c = (Decimal) userData.get('Rate_Hour__c');
      newUser.IsActive = true;
      newUser.ProfileId = (Id) userData.get('ProfileId');
      newUser.UserRoleId = roleId.get((String) userData.get('UserRole'));

      newUsers.add(newUser);
    }

    insert newUsers;
  }

  public static void createProjects(List<Map<String, Object>> projectDataList) {
    List<Project__c> newProjects = new List<Project__c>();
    Integer count = 0;

    for (Map<String, Object> projectData : projectDataList) {
      Project__c newProject = new Project__c();

      newProject.Name = 'Example Project ' + count;
      newProject.Start_Date__c = (Date) projectData.get('Start_Date__c');
      newProject.End_Date__c = (Date) projectData.get('End_Date__c');

      newProjects.add(newProject);
      count++;
    }

    insert newProjects;
  }
}