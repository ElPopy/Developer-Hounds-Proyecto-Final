trigger ProjectResourceTrigger on Project_Resources__c(
  after insert,
  before update
) {
  Boolean isAfterUpdate = Trigger.isAfter && Trigger.isUpdate;

  ProjectResourceHelper.afterCreate(Trigger.isInsert, Trigger.new);
  
  ProjectResourceHelper.beforeUpdate(
    isAfterUpdate,
    Trigger.new,
    Trigger.oldMap
  );
}

