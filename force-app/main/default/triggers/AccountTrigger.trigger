trigger AccountTrigger on Account (before insert, after update) {
   
    new MetadataTriggerManager()
        .setSObjectType('Account')
        .enableTrigger(true)
        .run();
}