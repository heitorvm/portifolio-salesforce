public with sharing class MetadataTriggerDAO {
   
    public static List<Trigger_Handler__mdt> getTriggerHandlers(String sObjectType) {
        return [
            SELECT
                Execution_Order__c, 
                Class_Name__c
            FROM
                Trigger_Handler__mdt
            WHERE
                sObjectType__c = :sObjectType
            AND
                Is_Active__c = TRUE
            ORDER BY 
                Execution_Order__c
        ];
    }

}