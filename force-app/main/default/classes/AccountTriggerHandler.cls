public with sharing class AccountTriggerHandler extends TriggerHandler {
    
    private final String ACCOUNT_NAME = 'Awesome Account Name';

    // Override method before insert in trigger. Param: Trigger.new
    public override void beforeInsert(List<SObject> newItems) {
        this.updateAccountName(newItems);
    }

    // Override method after update in trigger. Param: Trigger.newMap, Trigger.oldMap
    public override void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        this.updateContactAddress(newItems.values(), this.castSObjectToAccount(oldItems));
    }

    //  Update Account Name. Param: New accounts
    private void updateAccountName(List<Account> accounts) {
        for (Account account : accounts) {
            account.Name = this.ACCOUNT_NAME;
        }
    }

    // Update Contact address. Param: Accounts updated, Old version of accounts updated
    private void updateContactAddress(List<Account> accounts, Map<Id, Account> oldAccounts) {
        List<Contact> contacts = new List<Contact>();
        for (Account account : this.fetchAccountContacts(accounts)) {
            for (Contact contact : account.Contacts) {
                contact.MailingStreet = account.BillingStreet;
                contact.MailingCity = account.BillingCity;
                contact.MailingPostalCode = account.BillingState;
                contact.MailingCountry = account.BillingPostalCode;
                contact.MailingState = account.BillingCountry;
                contacts.add(contact);
            }
        }

        try {
            TriggerHandler.bypass('ContactTriggerHandler');
            update contacts;
        } catch (Exception ex) {
            throw ex;
        }
    }

    // Fetch related contacts to account. Param: Accounts updated. Return: List of account with related contacts
    private List<Account> fetchAccountContacts(List<Account> accounts) {
        return [SELECT Id, 
                       BillingStreet, 
                       BillingCity, 
                       BillingState, 
                       BillingPostalCode,
                       BillingCountry,
                       (SELECT Id,
                               MailingStreet, 
                               MailingCity, 
                               MailingPostalCode,
                               MailingCountry,
                               MailingState
                        FROM Contacts)
                FROM Account 
                WHERE Id IN :accounts];
    }

    // Cast generic SObject map to Account Map. Param: Generic SObject map. Return: Map of accounts
    private Map<Id, Account> castSObjectToAccount(Map<Id, SObject> items) {
        List<Account> accounts = items.values();
        return new Map<Id, Account>(accounts);
    }

}