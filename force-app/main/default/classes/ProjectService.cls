public with sharing class ProjectService {
  @AuraEnabled(cacheable=true)
  public static String methodName() {
    String response = '';
    try {
      return response;
    } catch (Exception e) {
      System.debug('ProjectService: ' + e.getMessage());
      throw new AuraHandledException(e.getMessage());
    }
  }
}
