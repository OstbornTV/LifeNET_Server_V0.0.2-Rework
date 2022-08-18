/*
    File: remoteExec.cpp
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Remote exec config for security system. 
*/
class cat_alarm_fnc_houseAlarm {
    allowedTargets=1;
};
class cat_alarm_fnc_houseAlarmMarker {
    allowedTargets=1;
};
class cat_alarm_fnc_addSecurity {
    allowedTargets=2;
};
class cat_alarm_fnc_loadSecurity {
    allowedTargets=2;
};
class cat_alarm_fnc_addSecurityHC {
    allowedTargets=HC_Life;
};
class cat_alarm_fnc_loadSecurityHC {
    allowedTargets=HC_Life;
};