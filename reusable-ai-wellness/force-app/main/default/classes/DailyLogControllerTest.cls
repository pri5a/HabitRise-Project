@isTest
public class DailyLogControllerTest {
    @isTest 
    static void testSaveDailyLogSuccess(){
        //Prepare JSON payload
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('Date__c', Date.today().format());
        payload.put('Meals__c', 'Breakfast: oats; Lunch: dal rice');
        payload.put('Workout__c','30 min run');
        payload.put('Sleep_Hours__c', 7);
        payload.put('HRV__c', 50);
        payload.put('RHR__c', 60);
        payload.put('Calories_Burned__c', 300);
        payload.put('Mood__c', 'Good');

        String jsonPayload = JSON.serialize(payload);

        Test.startTest();
        DailyLogController.SaveResult result = DailyLogController.saveDailyLog(jsonPayload);
        Test.stopTest();

        System.assert(result != null, 'Result should not be null');
        System.assert(result.success, 'Save should succeed: ' +result.error);
        System.assertNotEquals(null, result.recordId, 'Record Id should be returned');

        //verify record exists
        Daily_Log__c inserted = [SELECT Id, Meals__c, Workout__c from Daily_Log__c WHERE Id =:result.recordId LIMIT 1];
        System.assertEquals('30 min run', inserted.Workout__c);
    }

    @isTest 
    static void testSaveDailyLogMissingDate(){
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('Meals__c', 'Only meals - no date');

        String jsonPayload = JSON.serialize(payload);

        Test.startTest();
        DailyLogController.SaveResult result = DailyLogController.saveDailyLog(jsonPayload);
        Test.stopTest();

        System.assert(result != null);
        System.assert(!result.success, 'should fail because date is missing');
        System.assert(result.error != null && result.error.contains('Date is required'), 'Expected date validation error, got: ' + result.error);
    }

    @isTest
    static void testGetDailyLogs(){
        // Insert a test record
        Daily_Log__c log = new Daily_Log__c(
            Date__c = Date.today(),
            Meals__c = 'Test Meal',
            Workout__c = 'Test Workout'
        );
        insert log;

        Test.startTest();
        List<Daily_Log__c> logs = DailyLogController.getDailyLogs();
        Test.stopTest();

        System.assert(logs.size() > 0, 'Logs should be returned');
    }
}