public with sharing class validateProjectHandler {
    public static void validateProjectCompletion(List<Project__c> projectList) {
        // Recopilamos todos los ID de Proyectos que están siendo actualizados
        Set<Id> projectIds = new Set<Id>();
        for (Project__c project : projectList) {
            projectIds.add(project.Id);
        }
    
        // Buscamos todas las ProjectTask__c relacionadas con los proyectos en actualización
        List<Project_Task__c> projectTasks = [        SELECT Id, Status__c, Project__c        FROM Project_Task__c        WHERE Project__c IN :projectIds    ];
    
      
        


        // Iteramos por cada Project__c actualizado y verificamos si está siendo marcado como "Completed"
        for (Project__c project : projectList) {
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

    public static void assignSquadLead(List<Project__c> projectList, Map<Id, Project__c> oldMap) {
        if (oldMap.isEmpty()) { // Se crea un nuevo registro
            for (Project__c project : projectList) {
                if (project.Squad_Lead__c != null) {
                    project.addError('No se puede asignar un Squad Lead al crear un nuevo proyecto');
                }
            }
        } else { // Se actualiza un registro existente
            Set<Id> projectIds = new Set<Id>();
            for (Project__c project : projectList) {
                projectIds.add(project.Id);
            } 
    
            Set<Id> projectResourceIds = new Set<Id>();
            List<Project_Resources__c> projects = [SELECT Id, Resource__c, Project__c FROM Project_Resources__c WHERE Project__c IN :projectIds];
            for(Project_Resources__c project : projects){
                projectResourceIds.add(project.Resource__c);
            }
    
            for (Project__c project : projectList) {
              /*  if (project.Status__c != 'Pre-Kickoff') {
                    project.addError('No se puede asignar al Squad Lead ya que el proyecto no está en el estado "Pre-Kickoff".');
                } */
    
                 if(oldMap.get(project.Id).Status__c == 'Pre-Kickoff' && (project.Status__c == 'In progress' || project.Status__c == 'Completed'))
                {
                    if (project.Squad_Lead__c == null) {
                          project.addError('El campo Squad Lead no puede ser nulo al actualizar un proyecto');
                        //System.debug('El campo Squad Lead no puede ser nulo al actualizar un proyecto');
                      } else if (!projectResourceIds.contains(project.Squad_Lead__c)  ) {
                          project.addError('No se puede asignar al Squad Lead ya que no corresponde al proyecto');
                      }
                }
                 if ( project.Squad_Lead__c != null && !projectResourceIds.contains(project.Squad_Lead__c)  ) {
                    project.addError('No se puede asignar al Squad Lead ya que no corresponde al proyecto');
                }
                if(oldMap.get(project.Id).Status__c == 'Financial loss' && project.Status__c == 'In progress' )
                {
                    if(project.Estimated_Cost__c > project.Revenue__c)
                    {
                        project.addError('El costo estimado no puede ser mayor a los ingresos');
                    }	
                   
                }
                if(project.Estimated_Cost__c > project.Revenue__c)
                {
                    project.Status__c='Financial loss';
                }
            }
        }
    }
    
    /* public static void statusLoss(List<Project__c> projectList) 
    {
        for (Project__c project : projectList) {
            if(project.Estimated_Cost__c > project.Revenue__c)
            {
                project.Status__c='Financial loss';
            }
        }
    } */

 }