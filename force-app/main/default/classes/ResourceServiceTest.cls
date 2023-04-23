@isTest
public class ResourceServiceTest {
  // Project              S-------E
  // User       s---------e
  // User                         s---------e
  // User3    s--------e      s---------e
  // User           s---------e

  // User2    s--------e             s---------e
  // User1      [---]   [---]  [---]  [----]

  @isTest
  static void shoudlReturnErikaAndMaxi() {
    User erika = new User(
      FirsName = 'Erika',
      LastName = 'A',
      Rol__c = 'Arquitect',
      Rate_Hour__c = 10
    );
    User max = new User(
      FirstName = 'Maxi',
      LastName = 'B',
      Rol__c = 'Developer',
      Rate_Hour__c = 9
    );

    Project_Resources__c erika = 
  }
}
