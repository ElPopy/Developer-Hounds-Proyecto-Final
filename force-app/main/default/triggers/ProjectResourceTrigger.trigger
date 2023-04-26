trigger ProjectResourceTrigger on Project_Resources__c(
  before insert,
  before update
) {
  Boolean isBeforeCreate = Trigger.isBefore && Trigger.isInsert;
  Boolean isBeforeUpdate = Trigger.isBefore && Trigger.isUpdate;

  ProjectResourceHelper.beforeCreate(isBeforeCreate, Trigger.new);
  ProjectResourceHelper.beforeUpdate(
    isBeforeUpdate,
    Trigger.new,
    Trigger.oldMap
  );
}
