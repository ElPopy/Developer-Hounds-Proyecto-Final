@isTest
public class ResourceServiceTest {
  static final String PROJET_MANAGER = 'Project_Manager';
  static final String DEVELOPER = 'Developer';
  static final String ARCHITECH = 'Arquitect';
  static final String CONSULTANT = 'Consultant';

  @testSetup
  static void setup() {
    Id pmProfileId = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Project Manager'
      LIMIT 1
    ]
    .Id;    

    TestUtil.createUsers(
      new List<Map<String, Object>>{
        new Map<String, Object>{
          'FirstName' => 'Erika',
          'Rate_Hour__c' => 10,
          'ProfileId' => pmProfileId,
          'UserRole' => RoleName.DEVELOPER
        },
        new Map<String, Object>{
          'FirstName' => 'Max',
          'Rate_Hour__c' => 9,
          'ProfileId' => pmProfileId,
          'UserRole' => RoleName.CONSULTANT
        }
      }
    );
  }
  /*
    -all resources are available
    -Project              S-------E
    -Erika
    -Max

    -get available resources frees before project start
    -Project              S-------E
    -Erika      s---------e
    -Max                        s---------e

    -available resources during project duration(widthout repeted)
    -Project              S-------E
    -Erika      s---------e
    -Max                          s---------e

    -available resources during project duration(width repeted)
    -Project              S-------E
    -Erika      s---------e       s---------e
    -Max                          s---------e

    -Case without test
    -Project              S-------E
    -                         s---e
  */
  @isTest
  static void shoudlReturnErikaAndMax() {
    Set<Id> selectedRoleIds = new Set<Id>();
    List<UserRole> roles = [
      SELECT Id
      FROM UserRole
      WHERE Name = :DEVELOPER OR Name = :CONSULTANT
    ];
    for (UserRole role : roles) {
      selectedRoleIds.add(role.Id);
    }

    Test.startTest();

    Date projectStartDate = Date.newInstance(2023, 4, 23);
    Date projectEndDate = Date.newInstance(2023, 4, 26);

    List<ResourceWrapper> availableResources = ResourceService.queryAvailableResources(
      projectStartDate,
      projectEndDate,
      selectedRoleIds
    );

    Test.stopTest();

    System.assertEquals(2, availableResources.size(), 'wrong list size');
  }

  @isTest
  static void shoudlReturnErikaForProjectFrom2304To2604() {
    Set<Id> selectedRoleIds = new Set<Id>();
    List<UserRole> roles = [
      SELECT Id
      FROM UserRole
      WHERE Name = :DEVELOPER OR Name = :CONSULTANT
    ];
    for (UserRole role : roles) {
      selectedRoleIds.add(role.Id);
    }
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
      projectEndDate,
      selectedRoleIds
    );

    Test.stopTest();

    Id actualId = availableResources.get(0).id;

    System.assertEquals(1, availableResources.size(), 'wrong list size');
    // System.assertEquals(erikaId, actualId, 'wrong Id');
  }

  @isTest
  static void shoudlReturnErikaAndMaxForProjectFrom2304To2604() {
    Set<Id> selectedRoleIds = new Set<Id>();
    List<UserRole> roles = [
      SELECT Id
      FROM UserRole
      WHERE Name = :DEVELOPER OR Name = :CONSULTANT
    ];
    for (UserRole role : roles) {
      selectedRoleIds.add(role.Id);
    }
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
    Id maxId = projectManagers.get(1).Id;

    List<Project_Resources__c> prToInsert = new List<Project_Resources__c>();
    Project_Resources__c erikabussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 17),
      End_Date__c = Date.newInstance(2023, 4, 23),
      Resource__c = erikaId
    );
    Project_Resources__c maxbussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 26),
      End_Date__c = Date.newInstance(2023, 4, 30),
      Resource__c = maxId
    );
    prToInsert.add(erikabussy);
    prToInsert.add(maxbussy);

    insert prToInsert;

    Test.startTest();

    Date projectStartDate = Date.newInstance(2023, 4, 23);
    Date projectEndDate = Date.newInstance(2023, 4, 26);

    List<ResourceWrapper> availableResources = ResourceService.queryAvailableResources(
      projectStartDate,
      projectEndDate,
      selectedRoleIds
    );

    Test.stopTest();

    Id actualErikaId = availableResources.get(0).id;
    Id actualMaxId = availableResources.get(1).id;

    System.assertEquals(2, availableResources.size(), 'wrong list size');
    // System.assertEquals(erikaId, actualErikaId, 'wrong Id');
    // System.assertEquals(maxId, actualMaxId, 'wrong Id');
  }

  @isTest
  static void shoudlReturnErikaOnesAndMaxForProjectFrom2304To2604() {
    Set<Id> selectedRoleIds = new Set<Id>();
    List<UserRole> roles = [
      SELECT Id
      FROM UserRole
      WHERE Name = :DEVELOPER OR Name = :CONSULTANT
    ];
    for (UserRole role : roles) {
      selectedRoleIds.add(role.Id);
    }
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
    Id maxId = projectManagers.get(1).Id;

    List<Project_Resources__c> prToInsert = new List<Project_Resources__c>();
    Project_Resources__c erikabussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 17),
      End_Date__c = Date.newInstance(2023, 4, 23),
      Resource__c = erikaId
    );
    Project_Resources__c erikabussy2 = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 27),
      End_Date__c = Date.newInstance(2023, 4, 29),
      Resource__c = erikaId
    );

    Project_Resources__c maxbussy = new Project_Resources__c(
      Start_Date__c = Date.newInstance(2023, 4, 26),
      End_Date__c = Date.newInstance(2023, 4, 30),
      Resource__c = maxId
    );
    prToInsert.add(erikabussy);
    prToInsert.add(erikabussy2);

    prToInsert.add(maxbussy);

    insert prToInsert;

    Test.startTest();

    Date projectStartDate = Date.newInstance(2023, 4, 23);
    Date projectEndDate = Date.newInstance(2023, 4, 26);

    List<ResourceWrapper> availableResources = ResourceService.queryAvailableResources(
      projectStartDate,
      projectEndDate,
      selectedRoleIds
    );

    Test.stopTest();

    Id actualErikaId = availableResources.get(0).id;
    Id actualMaxId = availableResources.get(1).id;

    System.assertEquals(2, availableResources.size(), 'wrong list size');
    // System.assertEquals(erikaId, actualErikaId, 'wrong Id');
    // System.assertEquals(maxId, actualMaxId, 'wrong Id');
  }
}