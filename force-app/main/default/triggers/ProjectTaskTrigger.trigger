trigger ProjectTaskTrigger on Project_Task__c (before insert) {
    Id currentUserId = UserInfo.getUserId();
    Project_Resources__c squadLead;
    try {
        squadLead = [SELECT Id 
                     FROM Project_Resources__c 
                     WHERE Resource__c = :currentUserId 
                     AND is_Squad_Leader__c = true 
                     LIMIT 1];
    } catch (QueryException e) {
        for (Project_Task__c task : Trigger.new) {
            task.addError('Error retrieving Squad Lead information. Please contact your system administrator.');
        }
        return;
    }
    if (squadLead == null) {
        for (Project_Task__c task : Trigger.new) {
            task.addError('You must be a Squad Lead to create a Project Task.');
        }
    }
}