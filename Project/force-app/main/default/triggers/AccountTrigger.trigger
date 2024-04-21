trigger AccountTrigger on Account (After insert, After update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            AccountTriggerHandler.accountTrigger(Trigger.newMap, Trigger.oldMap);
        }
    }
}