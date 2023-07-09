public with sharing class MetadataTriggerManager {
    
    private final String TRIGGER_OBJECT_REQUIRED = 'Must set trigger sobject';
    private final String SOMETHING_WENT_WRONG = 'Something went wrong. Please contact administrator.';
    private Boolean isTriggerEnabled = true;
    private String sObjectType;

    // Run trigger handlers. Example: new MetadataTriggerManager().enableTrigger(true).setSObjectType('ObjectXXX').run();
    public void run() {
        if (!this.isTriggerEnabled) {
            return;
        }

        if (this.isTriggerEnabled && String.isBlank(this.sObjectType)) {
            throw new MetadataTriggerManagerException(this.TRIGGER_OBJECT_REQUIRED);
        }

        try {
            for (Trigger_Handler__mdt metadata : this.fetchTriggerHandlers()) {
                Type handler = this.constructApexType(metadata.Class_Name__c);
                if (handler != null && this.isValid(handler)) {
                    this.executeHandler(handler);
                }
            }
        } catch (Exception ex) {
            throw new MetadataTriggerManagerException(this.SOMETHING_WENT_WRONG);
        }
    }

    // Fetch all active trigger handlers on specific object
    private List<Trigger_Handler__mdt> fetchTriggerHandlers() {
        return MetadataTriggerDAO.getTriggerHandlers(this.sObjectType);
    }

    // Validate if trigger handler class is not included in bypass and parent class is TriggerHandler. Param: Apex type that corresponds to an Apex class
    @TestVisible
    private Type constructApexType(String className) {
        Type apexType;
        try {
            apexType = Type.forName(className);
        } catch (Exception ex) {
            return null;
        }
        return apexType;
    }

    // Validate if trigger handler class is not included in bypass and parent class is TriggerHandler. Param: Apex type that corresponds to an Apex class 
    @TestVisible
    private Boolean isValid(Type handler) {
        Boolean isBypassed = TriggerHandler.isByPassed(handler.getName());
        Boolean isTriggerHandlerType = TriggerHandler.class.isAssignableFrom(handler);
        return !isBypassed && isTriggerHandlerType;
    }

    // Execute Trigger handler. Param: Apex type that corresponds to an Apex class 
    @TestVisible
    private void executeHandler(Type handler) {
        TriggerHandlerDispatcher.run(this.injectHandler(handler));
        TriggerHandler.clearByPasses();
    }

    // Instantiate TriggerHandler class. Param: Apex type that corresponds to an Apex class
    private TriggerHandler injectHandler(Type handler) {
        return (TriggerHandler) handler.newInstance();
    }

    // Enable trigger manager. Param: Determines if trigger is enabled
    public MetadataTriggerManager enableTrigger(Boolean isTriggerEnabled) {
        this.isTriggerEnabled = isTriggerEnabled;
        return this;
    }

    // Set SObject Type for fetching trigger handlers. Param: Trigger SObject
    public MetadataTriggerManager setSObjectType(String sObjectType) {
        this.sObjectType = sObjectType;
        return this;
    }

    // Custom Exception
    public class MetadataTriggerManagerException extends Exception {}

}