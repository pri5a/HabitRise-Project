public with sharing class DailyLogController {

    public class SaveResult {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Id recordId;
        @AuraEnabled public String error;
    }

     /**
     * Expects a JSON string. Example JSON keys should match field API names:
     * { "Date__c":"2025-09-25", "Meals__c":"...", "Workout__c":"...", "Sleep_Hours__c":7, "HRV__c":45, "RHR__c":60, "Calories_Burned__c":300, "Mood__c":"Good" }
     */
    @AuraEnabled
    public static SaveResult saveDailyLog(String jsonData){
        SaveResult result = new SaveResult();
        result.success = false;
        result.recordId = null;
        result.error = null;

        try {
            if(jsonData == null){
                result.error = 'Missing input data';
                return result;
            }

            //Parse JSON
            Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(jsonData);

            //Basic validations
            if(!data.containsKey('Date__c') || data.get('Date__c') == null || String.valueOf(data.get('Date__c')).trim() == ''){
                result.error = 'Date is required.';
                return result;
            }

            //Permission checks (object and field creatable)
            if(!Schema.sObjectType.Daily_Log__c.isCreateable()){
                result.error = 'Insufficient permissions to create Daily Log record';
                return result;
            }
            if(!Schema.sObjectType.Daily_Log__c.fields.Date__c.isCreateable()){
                result.error = 'Insufficient field-level permission for Date__c';
                return result;
            }

            //Build the record
            Daily_Log__c rec = new Daily_Log__c();

            //Date (expect yyyy-MM-dd)
            String dateStr = String.valueOf(data.get('Date__c'));
            if(String.isNotBlank(dateStr)){
                rec.Date__c = Date.valueOf(dateStr);
            }

            //Optional text / number fields
            if(data.containsKey('Meals__c')) rec.Meals__c = String.valueOf(data.get('Meals__c'));
            if(data.containsKey('Workout__c')) rec.Workout__c = String.valueOf(data.get('Workout__c'));
            
            if(data.containsKey('Sleep_Hours__c') && data.get('Sleep_Hours__c') != null){
                rec.Sleep_Hours__c = Decimal.valueOf(String.valueOf(data.get('Sleep_Hours__c')));
            }

            if(data.containsKey('HRV__c') && data.get('HRV__c') != null){
                rec.HRV__c = Decimal.valueOf(String.valueOf(data.get('HRV__c')));
            }

            if(data.containsKey('RHR__c') && data.get('RHR__c') != null){
                rec.RHR__c = Decimal.valueOf(String.valueOf(data.get('RHR__c')));
            }

            if(data.containsKey('Calories_Burned__c') && data.get('Calories_Burned__c') != null){
                rec.Calories_Burned__c = Decimal.valueOf(String.valueOf(data.get('Calories_Burned__c')));
            }

            if(data.containsKey('Mood__c')) rec.Mood__c = String.valueOf(data.get('Mood__c'));

            //Insert with try-catch to return friendly error
            insert rec;

            result.success = true;
            result.recordId = rec.Id;
            return result;
        } catch(Exception ex){
            //Return friendly error text; don't leak sensitive internals
            result.error = ex.getMessage();
            return result;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Daily_Log__c> getDailyLogs(){
        //Field-level security check
        if(!Schema.sObjectType.Daily_Log__c.isAccessible()){
            throw new AuraHandledException('Access Denied');
        }
        return [
            SELECT Id, Date__c, Meals__c, Workout__c, Sleep_Hours__c, Mood__c
            FROM Daily_Log__c
            ORDER BY Date__c DESC
        ];
    }

}