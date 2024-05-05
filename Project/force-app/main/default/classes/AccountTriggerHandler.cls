
public class AccountTriggerHandler {
    public static void accountTrigger(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        Set<Id> accountIdsWithContacts = new Set<Id>();
        List<Contact> newContacts = new List<Contact>();

        for (Contact existingContact : [SELECT AccountId FROM Contact WHERE AccountId IN :newMap.keySet()]) {
            accountIdsWithContacts.add(existingContact.AccountId);
        }
		
        
        for (Id accountId : newMap.keySet()) {
            Account newAccount = newMap.get(accountId);
            Account oldAccount = oldMap != null ? oldMap.get(accountId) : null;

            if (newAccount.Type.contains('Customer') && newAccount.VGActive__c && isCustomerAccountType(newAccount.Type) && (Trigger.isInsert || (Trigger.isUpdate && (oldAccount == null || !oldAccount.VGActive__c)))) {
                if (!accountIdsWithContacts.contains(accountId)) {
                    newContacts.add(new Contact(
                        FirstName = newAccount.Name,
                        LastName = 'Customer Representative',
                        Phone = newAccount.Phone,
                        Email = newAccount.Company_Email__c,
                        AccountId = accountId
                    ));
                    accountIdsWithContacts.add(accountId); 
                }
            }
        }

        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
public static Boolean isCustomerAccountType(String accountType) {
    if (accountType == null) {
        return false;
    }
    return accountType.startsWith('Customer');
}
}
