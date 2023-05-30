@isTest
public class ProjectServiceTest {
  @testSetup
  static void setup() {
    TestUtil.createProjects(
      new List<Map<String, Object>>{
        new Map<String, Object>{
          'Start_Date__c' => Date.newInstance(2023, 4, 23),
          'End_Date__c' => Date.newInstance(2023, 4, 26)
        }
      }
    );
  }

  @isTest
  static void shouldCreateProjects() {
    List<Project__c> projects = [SELECT Start_Date__c FROM Project__c];
    System.assertEquals(1, projects.size(), 'wrong size');
  }

  @isTest
  static void shouldreturn100HoursOfConsultant() {
    List<Project__c> projects = [SELECT Id FROM Project__c];
    Id projectId = projects.get(0).Id;

    ProjectLineItem__c newPosition = new ProjectLineItem__c();
    newPosition.Project__c = projectId;
    newPosition.Rol__c = RoleName.CONSULTANT;
    newPosition.RequiredHoursxRol__c = 250;
    newPosition.AssignedHousxRol__c = 100;

    insert newPosition;

    Test.startTest();

    String response = ProjectService.getAllocationData(projectId);

    Test.stopTest();

    ProjectWrapper project = (ProjectWrapper) JSON.deserializeStrict(
      response,
      ProjectWrapper.class
    );
    List<PositionWrapper> positions = project.projectLineItems;
    String positionId = positions.get(0).positionId;
    String role = positions.get(0).role;
    Decimal soldHoursToCover = positions.get(0).soldHoursToCover;
    List<ResourceWrapper> availableResources = positions.get(0)
      .availableResource;

    System.assertEquals(1, positions.size(), 'wrong positions size');
    System.assertEquals(newPosition.Id, positionId, 'wrong position Id');
    System.assertEquals(RoleName.CONSULTANT, role, 'wrong role');
    System.assertEquals(150, soldHoursToCover, 'wrong required hours');
    System.assertEquals(2, availableResources.size(), 'bad available size');
  }
}