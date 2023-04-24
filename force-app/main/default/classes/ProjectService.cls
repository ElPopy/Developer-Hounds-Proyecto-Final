public with sharing class ProjectService {
  @AuraEnabled(cacheable=true)
  public static String getAllocationData(Id projectId) {
    try {
      Project__c project = [
        SELECT
          Start_Date__c,
          End_Date__c,
          (
            SELECT Rol__c, SodlHoursToCover__c
            FROM ProjectLineItems__r
          )
        FROM Project__c
        WHERE Id = :projectId
      ];
      ProjectWrapper wrapper = new ProjectWrapper(project);
      return JSON.serialize(wrapper);
    } catch (Exception e) {
      System.debug('ProjectService: ' + e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }
}
