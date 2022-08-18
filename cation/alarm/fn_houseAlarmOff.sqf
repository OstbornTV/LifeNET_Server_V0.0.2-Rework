/*
    File: fn_houseAlarmOff.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Turns house alarm off.
*/
private ["_house"];
_house = param [0,objNull,[objNull]];
closeDialog 0;

_house setVariable ["alarm",false,true];
deleteMarkerLocal format ["alarm_%1",(_house getVariable "house_id")];