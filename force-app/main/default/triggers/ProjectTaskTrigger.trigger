/*trigger ProjectTaskTrigger on Project_Task__c (before insert) {
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

*/
trigger ProjectTaskTrigger on Project_Task__c (before insert) {
    Id currentUserId = UserInfo.getUserId();
    for (Project_Task__c task : Trigger.new) {
        Id projectId = task.Project__c;
        if (projectId == null) {
            task.addError('A Project must be selected for this task.');
            return;
        }
        Project_Resources__c squadLead;
        try {
            squadLead = [SELECT Id 
                         FROM Project_Resources__c 
                         WHERE Resource__c = :currentUserId 
                         AND is_Squad_Leader__c = true 
                         AND Project__c = :projectId
                         LIMIT 1];
        } catch (QueryException e) {
            task.addError('debes ser parte del proyecto o ser squad lead para poder crear una tarea');
            return;
        }
        if (squadLead == null) {
            task.addError('You must be a Squad Lead for this Project to create a Project Task.');
        }
    }
}