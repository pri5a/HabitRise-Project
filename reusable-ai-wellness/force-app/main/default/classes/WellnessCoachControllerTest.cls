@isTest
public class WellnessCoachControllerTest {
    @isTest
    static void testFeedback() {
        Daily_Log__c log = new Daily_Log__c(
            Date__c = Date.today(),
            Meals__c = 'Daal Rice',
            Workout__c = 'Run',
            Sleep_Hours__c = 5,
            Calories_Burned__c = 350,
            Mood__c = 'Okay'
        );
        insert log;

        Test.startTest();
        WellnessCoachController.Feedback fb = WellnessCoachController.getFeedback(log.Id);
        Test.stopTest();

        System.assertNotEquals(null, fb, 'Feedback should not be null');
        System.assert(fb.message.contains('sleep'), 'Feedback should mention sleep.');
    }
}