public class EinsteinChatBotController {  

    public class TesteOutput {
        @InvocableVariable
	    public String shift;

    }
 
    @InvocableMethod(label='Get Case Status') 
    public static List < TesteOutput > fetchCaseStatus( List < ScheduleAppointmentInvocableParameters > listCaseInputs ) { 
      
        Boolean nullValue = false;
        
        for(ScheduleAppointmentInvocableParameters ci : listCaseInputs){
            if(ci.shift == null)
                nullValue = true;
        }
     
        List < TesteOutput > objOutputs = new List < TesteOutput >(); 
        TesteOutput objOutput = new TesteOutput(); 
        Set < String > strCaseNumbers = new Set < String >(); 
        for ( ScheduleAppointmentInvocableParameters objCaseInput : listCaseInputs ) 
            strCaseNumbers.add( objCaseInput.shift ); 
        objOutput.shift = 'teste: ' + nullValue; 
        objOutputs.add( objOutput );  
        return objOutputs; 
     
    } 
 
}