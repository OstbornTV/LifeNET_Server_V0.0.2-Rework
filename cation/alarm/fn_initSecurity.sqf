/*
    File: fn_initSecurity.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Initializes security system.
*/
[] spawn {
    if (!hasInterface) exitWith {};
	waitUntil {!isNull (findDisplay 46)};
    private["_uid","_sender"];
    _sender = player;
    _uid = getPlayerUID _sender;
    if (getNumber(missionConfigFile >> "Cation_Alarm" >> "HeadlessSupport") isEqualTo 0) then {
        [_uid,_sender] remoteExec ["cat_alarm_fnc_loadSecurity",2];
    } else {
        if (life_HC_isActive) then {
            [_uid,_sender] remoteExec ["cat_alarm_fnc_loadSecurityHC",HC_Life];
        } else {
            [_uid,_sender] remoteExec ["cat_alarm_fnc_loadSecurity",2];
        };
    };
    
};