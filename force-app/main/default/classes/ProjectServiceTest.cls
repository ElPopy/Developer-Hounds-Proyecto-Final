@isTest
public class ProjectServiceTest {
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

    Set<String> roleNames = new Set<String>{
      PROJET_MANAGER,
      DEVELOPER,
      ARCHITECH,
      CONSULTANT
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

    TestUtil.createUsers(
      new List<Map<String, Object>>{
        new Map<String, Object>{
          'FirstName' => 'Rama',
          'Rate_Hour__c' => 11,
          'ProfileId' => pmProfileId,
          'UserRoleId' => roleId.get(CONSULTANT)
        }
      }
    );
  }

  @isTest
  static void shouldCreateProjects() {
    TestUtil.createProjects(
      new List<Map<String, Object>>{
        new Map<String, Object>{
          'Start_Date__c' => Date.newInstance(2023, 4, 23),
          'End_Date__c' => Date.newInstance(2023, 4, 26)
        }
      }
    );
    List<Project__c> projects = [SELECT Start_Date__c FROM Project__c];
    System.assertEquals(1, projects.size(), 'wrong size');
  }
}
