public with sharing class WellnessCoachController {
    public class Feedback {
        @AuraEnabled public String message;
        @AuraEnabled public String moodTip;
    }

    @AuraEnabled(cacheable=false)
    public static Feedback getFeedback(Id recordId) {
        Feedback fb = new Feedback();

        if(recordId == null) {
            fb.message = 'No record selected. Please log todays data first.';
            return fb;
        }

        Daily_Log__c log = [
            SELECT Date__c, Meals__c, Workout__c, Sleep_Hours__c, HRV__c, RHR__c, Calories_Burned__c, Mood__c
            FROM Daily_Log__c
            WHERE Id = :recordId
            LIMIT 1
        ];

        String message = '';

        if(log.Sleep_Hours__c < 6) {
            message += 'You should aim for at least 6 hours of sleep each night. ';
        } else if (log.Sleep_Hours__c >= 7){
            message += 'You are getting enough sleep. ';
        }

        if(log.Calories_Burned__c > 400){
            message += 'Excellent activity level today! ';
        } else {
            message += 'try adding a short evening walk. ';
        }

        if(log.Mood__c != null && log.Mood__c.containsIgnoreCase('good')) {
            message += 'keep up the positive energy. ';
        } else {
            message += 'Reflect and unwind with light breathing exercises. ';
        }

        fb.message = message;
        fb.moodTip = 'Tip: Track your mood daily to improve consistency. ';
        return fb;
    }
}