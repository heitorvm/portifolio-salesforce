public virtual class TriggerHandler {
    
    private static Set<String> bypassHandlers = new Set<String>();

    // Run method before insert in trigger. Param: Trigger.new
    public virtual void beforeInsert(List<SObject> newItems) {}

    // Run method before update in trigger. Param: Trigger.newMap, Trigger.oldMap
    public virtual void beforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    // Run method before delete in trigger. Param: Trigger.oldMap
    public virtual void beforeDelete(Map<Id, SObject> oldItems) {}

    // Run method after insert in trigger. Param: Trigger.newMap
    public virtual void afterInsert(Map<Id, SObject> newItems) {}

    // Run method after update in trigger. Param: Trigger.newMap, Trigger.oldMap
    public virtual void afterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    // Run method after delete in trigger. Trigger.oldMap
    public virtual void afterDelete(Map<Id, SObject> oldItems) {}

    // Run method after undelete in trigger. Trigger.oldMap
    public virtual void afterUndelete(Map<Id, SObject> oldItems) {}

    // Bypass trigger/apex class before class execution. Param: handlerName
    public static void bypass(String handlerName) {
        bypassHandlers.add(handlerName);
    }

    // Remove/Enable apex class before class execution. Param: handlerName
    public static void clearByPass(String handlerName) {
        bypassHandlers.remove(handlerName);
    }

    // Check if class was bypassed. Param: handlerName
    public static Boolean isByPassed(String handlerName) {
        return bypassHandlers.contains(handlerName);
    }

    // Clear all bypass classes
    public static void clearByPasses() {
        bypassHandlers.clear();
    }

}