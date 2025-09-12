public with sharing class JSONToObjectRecordHandlerSchedule implements Schedulable {
    public void execute(SchedulableContext context){
        if(!JSONToObjectRecordHandler.processedEvents.isEmpty()){
            JSONToObjectRecordHandler.processEvents(JSONToObjectRecordHandler.processedEvents);
            JSONToObjectRecordHandler.processedEvents.clear();
        }
    }
}