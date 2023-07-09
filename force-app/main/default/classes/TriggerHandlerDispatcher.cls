public with sharing class TriggerHandlerDispatcher {
    
    private static Set<Id> hasBeenRunAfter = new Set<Id>();
    private static Set<Id> hasBeenRunBefore = new Set<Id>();
    
    @TestVisible
    private static TriggerOperation triggerContext = Trigger.operationType;

    // Main method to run trigger events. Param: TriggerHandler Class. Example: TriggerDispatcher.run(new TriggerHandler());
    public static void run(TriggerHandler handler) {
        if (!Trigger.isExecuting && !Test.isRunningTest()) {
            throw new TriggerHandlerDispatcherException('Trigger handler called outside of Trigger execution');
        }

        List<sObject> applicableSObjectsList = recursionChecker(isDeleteOrUndelete() ? Trigger.old : Trigger.new);
        if (!applicableSObjectsList.isEmpty()) {
            runEvents(handler, applicableSObjectsList);
        }
    }

    // Checks records if it already executed the process. Param: Applicable SObjects. Example: TriggerDispatcher.recursionChecker(new List<sObject>())
    @TestVisible
    private static List<sObject> recursionChecker(List<sObject> sObjectsList) {
        List<sObject> applicableSObjectsList = new List<sObject>();
        if (sObjectsList != null) {
            Boolean isBefore = isBefore();
            for (sObject sobj : sObjectsList) { 
                Id objId = sObj.get('Id') != null ? (Id) sobj.get('Id') : null;
                if((isBefore && !hasBeenRunBefore.contains(objId)
                    || (!isBefore)) && !hasBeenRunAfter.contains(objId)) {
                    applicableSObjectsList.add(sobj);
                    addProcessIds(objId, isBefore);
                }
            }
        }
        return applicableSObjectsList;
    }

    // Determine if trigger event is before or after
    private static Boolean isBefore() {
        String context = triggerContext.name();
        return context.contains('BEFORE');
    }

    // Determine if trigger event is delete or undelete
    private static Boolean isDeleteOrUndelete() {
        String context = triggerContext.name();
        return context.contains('DELETE') || context.contains('UNDELETE');
    }

    // Add process records Ids to set to avoid recursion. Param: Record Id, Trigger Context
    private static void addProcessIds(Id objId, Boolean isBefore) {
        if (objId != null) {
            if (isBefore) {
                hasBeenRunBefore.add(objId);
            } else {
                hasBeenRunAfter.add(objId);
            }
        }
    }

    // Execute method per trigger event (e.g. before insert, after, update, etc.). Param: TriggerHandler Class, Applicable Sobjects
    @TestVisible
    private static void runEvents(TriggerHandler handler, List<sObject> applicableSObjectsList) {
        switch on triggerContext {
            when BEFORE_INSERT {
                handler.beforeInsert(applicableSObjectsList);
            }
            when BEFORE_UPDATE {
                handler.beforeUpdate(new Map<Id, sObject>(applicableSObjectsList), Trigger.oldMap);
            }
            when BEFORE_DELETE {
                handler.beforeDelete(new Map<Id, sObject>(applicableSObjectsList));
            }
            when AFTER_INSERT {
                handler.afterInsert(new Map<Id, sObject>(applicableSObjectsList));
            }
            when AFTER_UPDATE {
                handler.afterUpdate(new Map<Id, sObject>(applicableSObjectsList), Trigger.oldMap);
            }
            when AFTER_DELETE {
                handler.afterDelete(new Map<Id, sObject>(applicableSObjectsList));
            }
            when AFTER_UNDELETE {
                handler.afterUndelete(new Map<Id, sObject>(applicableSObjectsList));
            }
        }
    }

    // Custom Exception
    public class TriggerHandlerDispatcherException extends Exception {}

}