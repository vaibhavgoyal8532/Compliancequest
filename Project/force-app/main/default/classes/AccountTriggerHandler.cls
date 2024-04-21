public class AccountTriggerHandler {
    public static void accountTrigger(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        List<Contact> newContacts = new List<Contact>();
   
        for (Id acc : newMap.KeySet()) {

                if (newMap.get(acc).Type != NULL && newMap.get(acc).VGActive__c && (Trigger.isInsert || (Trigger.isUpdate && !oldMap.get(acc).VGActive__c))) {
                    newContacts.add(new Contact(
                        
                        FirstName = newMap.get(acc).Name,
                    
                        LastName = 'Customer Representative',
                        Phone = newMap.get(acc).Phone,
                        Email = newMap.get(acc).Company_Email__c,
                        AccountId = newMap.get(acc).Id
                    ));
                }
            }
       

        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
}