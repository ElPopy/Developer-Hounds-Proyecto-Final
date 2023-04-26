trigger ProjectCompletionValidationTrigger on Project__c (before update) {
    // Recopilamos todos los ID de Proyectos que están siendo actualizados
    Set<Id> projectIds = new Set<Id>();
    for (Project__c project : Trigger.new) {
        projectIds.add(project.Id);
    }

    // Buscamos todas las ProjectTask__c relacionadas con los proyectos en actualización
    List<Project_Task__c> projectTasks = [
        SELECT Id, Status__c, Project__c
        FROM Project_Task__c
        WHERE Project__c IN :projectIds
    ];

    // Iteramos por cada Project__c actualizado y verificamos si está siendo marcado como "Completed"
    for (Project__c project : Trigger.new) {
        if (project.Status__c == 'Completed') {
            // Iteramos por cada ProjectTask__c relacionada y verificamos si alguna no ha sido completada
            for (Project_Task__c projectTask : projectTasks) {
                if (projectTask.Project__c == project.Id && projectTask.Status__c != 'Completed') {
                    // Si hay una ProjectTask__c relacionada con estado diferente de "Completed", lanzamos una excepción
                    project.addError('No puedes marcar este proyecto como "Completed" porque aún hay tareas pendientes.');
                    break;
                }
            }
        }
    }
}