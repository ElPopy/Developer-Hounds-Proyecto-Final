@isTest
public class ResourceServiceTest {
  @testSetup
  static void setup() {
    List<Map<String, Object>> userDataList = new List<Map<String, Object>>{
      new Map<String, Object>{
        'FirstName' => 'Erika',
        'LastName' => 'Doe',
        'Email' => 'erika@example.com',
        'Username' => 'erika@cloudconsulting.com',
        'Alias' => 'erid',
        'CommunityNickname' => 'eridoe',
        'LocaleSidKey' => 'en_US',
        'TimeZoneSidKey' => 'America/Los_Angeles',
        'EmailEncodingKey' => 'UTF-8',
        'LanguageLocaleKey' => 'en_US',
        'Rate_Hour__c' => 10,
        'IsActive' => true
      },
      new Map<String, Object>{
        'FirstName' => 'Max',
        'LastName' => 'Smith',
        'Email' => 'max@example.com',
        'Username' => 'max@couldconsulting.com',
        'Alias' => 'mbe',
        'CommunityNickname' => 'maxsmith',
        'LocaleSidKey' => 'en_US',
        'TimeZoneSidKey' => 'America/Los_Angeles',
        'EmailEncodingKey' => 'UTF-8',
        'LanguageLocaleKey' => 'en_US',
        'Rate_Hour__c' => 9,
        'IsActive' => true
      }
    };

    List<User> newUsers = new List<User>();

    for (Map<String, Object> userData : userDataList) {
      User newUser = new User();
      newUser.FirstName = (String) userData.get('FirstName');
      newUser.LastName = (String) userData.get('LastName');
      newUser.Email = (String) userData.get('Email');
      newUser.Username = (String) userData.get('Username');
      newUser.Alias = (String) userData.get('Alias');
      newUser.CommunityNickname = (String) userData.get('CommunityNickname');
      newUser.LocaleSidKey = (String) userData.get('LocaleSidKey');
      newUser.TimeZoneSidKey = (String) userData.get('TimeZoneSidKey');
      newUser.EmailEncodingKey = (String) userData.get('EmailEncodingKey');
      newUser.LanguageLocaleKey = (String) userData.get('LanguageLocaleKey');
      newUser.Rate_Hour__c = (Decimal) userData.get('Rate_Hour__c');
      newUser.IsActive = (Boolean) userData.get('IsActive');

      Id profileId = [
        SELECT Id
        FROM Profile
        WHERE Name = 'Project Manager'
        LIMIT 1
      ]
      .Id;
      newUser.ProfileId = profileId;

      Id roleId = [SELECT Id FROM UserRole WHERE Name = 'Developer' LIMIT 1].Id;
      newUser.UserRoleId = roleId;

      newUsers.add(newUser);
    }

    insert newUsers;
  }
  // Project              S-------E
  // User       s---------e
  // User                         s---------e
  // User3    s--------e      s---------e
  // User           s---------e

  // User2    s--------e             s---------e
  // User1      [---]   [---]  [---]  [----]

  @isTest
  static void shoudlReturnErikaForProjectFrom2304To2604() {
    Id profileId = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Project Manager'
      LIMIT 1
    ]
    .Id;
    List<User> projectManagers = [
      SELECT Id
      FROM User
      WHERE ProfileId = :profileId
    ];

    Id erikaId = projectManagers.get(0).Id;

    List<Project_Resources__c> prToInsert = new List<Project_Resources__c>();
    Project_Resources__c erikabussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 17),
      End_Date__c = Date.newInstance(2023, 4, 23),
      Resource__c = erikaId
    );
    Project_Resources__c maxbussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 24),
      End_Date__c = Date.newInstance(2023, 4, 30),
      Resource__c = projectManagers.get(1).Id
    );
    prToInsert.add(erikabussy);
    prToInsert.add(maxbussy);

    insert prToInsert;

    Test.startTest();

    Date projectStartDate = Date.newInstance(2023, 4, 23);
    Date projectEndDate = Date.newInstance(2023, 4, 26);

    List<ResourceWrapper> availableResources = ResourceService.queryAvailableResources(
      projectStartDate,
      projectEndDate
    );

    Test.stopTest();

    Id actualId = availableResources.get(0).id;

    System.assertEquals(1, availableResources.size(), 'wrong list size');
    System.assertEquals(erikaId, actualId, 'wrong Id');
  }
}
