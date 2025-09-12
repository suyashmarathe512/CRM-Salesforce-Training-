public class JSONEventScheduler {
    public static void scheduleJob() {
        String cronExp = '*/1 * * * *';
        JSONToObjectRecordHandlerSchedule job = new JSONToObjectRecordHandlerSchedule();
        System.schedule('JSONToObjectRecordHandlerScheduleJob', cronExp, job);
    }
}
