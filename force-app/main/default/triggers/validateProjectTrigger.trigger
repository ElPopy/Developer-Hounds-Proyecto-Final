trigger validateProjectTrigger on Project__c (before update, after update) {
    if(trigger.isBefore) {
        if(trigger.isUpdate)
        {
            validateProjectHandler.validateProjectCompletion(Trigger.new);
            validateProjectHandler.assignSquadLead(Trigger.new,Trigger.oldMap);
            system.debug('estoy aca trigger');
           
            
        }
            
            
        }
      /*  if(trigger.isAfter) {
            if(trigger.isUpdate)
            {
                validateProjectHandler.assignSquadLead(Trigger.new);
            }
            
        }*/


    }
   
 