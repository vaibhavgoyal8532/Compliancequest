@isTest
public class TestAccountActivationHandler {
    public static User u;
    public static PermissionSet ps;
    @testSetup
    public static void setup() {
 
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
	system.debug(p);
        
        ps = [SELECT Id FROM PermissionSet WHERE Name='Account_Manager'];
        system.debug(ps);
        
       u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='testpermissionsetuserAstreait@testorg.com');
        insert u;
	system.debug('user' + u);
        system.debug(' system.debug(UserInfo.getUserId()) '+UserInfo.getUserId());
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = u.Id,
            PermissionSetId = ps.Id
        );
        insert psa;
        
        
        
        System.runAs(u) {
             Account acc1 = new Account(
            Name = 'Test Account 1',
            Type = 'Customer',
            VGActive__c = true
        
        );
        insert acc1;
           Account acc2 = new Account(
            Name = 'Test Account 2',
            Type = 'Customer',
            VGActive__c = false
        
        );
        insert acc2;  
            
            
        }
            
    }

    @isTest
    public static void testAccountInsertion() {
        
        
            Account acc = [SELECT Id,Phone,Company_Email__c FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
            List<Contact> createdContacts = [SELECT Id,Phone,Email,LastName FROM Contact WHERE AccountId = :acc.Id];
            System.assertEquals(1, createdContacts.size(), 'Default contact not created for active customer account');
            System.assertEquals(createdContacts[0].Phone, acc.Phone);
            System.assertEquals(createdContacts[0].Email, acc.Company_Email__c);
            System.assertEquals(createdContacts[0].LastName,'Customer Representative');
        }
    
	
     @isTest
    public static void testAccountInsertionFalied() {
       
        
            Account acc = [SELECT Id,Phone,Company_Email__c FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
            List<Contact> createdContacts = [SELECT Id,Phone,Email,LastName FROM Contact WHERE AccountId = :acc.Id];
            System.assertEquals(0, createdContacts.size(), 'No contact should be created for an inactive customer account');
           
      
    }

    @isTest
    public static void testAccountUpdate() {
        
        
             Account acc = [SELECT Id,Phone,Company_Email__c,VGActive__c FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
            acc.VGActive__c = true;
            Test.startTest();
            update acc;
            Test.stopTest();
            List<Contact> createdContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            System.assertEquals(1, createdContacts.size(), 'Default contact not created for active customer account');
             System.assertEquals(acc.VGActive__c,true);
            
        }
    }
