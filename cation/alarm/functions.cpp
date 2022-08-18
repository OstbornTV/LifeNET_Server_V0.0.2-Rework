/*
    File: functions.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Function config for security system. 
*/
class Cation_Alarm {
    tag = "cat_alarm";
    class functions {
        file = "cation\alarm";        
        // Client      
        class getText {};  
        class houseAlarm {};
        class houseAlarmBuy {};
        class houseAlarmMarker {};
        class houseAlarmOff {};
        class initSecurity { postInit = 1; };
        // Server
        class addSecurity {};
        class loadSecurity {};    
        // HC_Life
        class addSecurityHC {};
        class loadSecurityHC {};        
    };
};