@isTest
public class DailyLogtest {
    @isTest
    static void insertDailyLog(){
        Daily_Log__c log = new Daily_Log__c(
            Date__c = Date.today(),
            Meals__c = 'Sample Meals',
            Workout__c = 'Running',
            Sleep_Hours__c = 7
        );
        insert log;
        System.assertNotEquals(null, log.Id);
    }
}