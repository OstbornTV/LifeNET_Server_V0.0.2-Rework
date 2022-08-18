/*
    File: fn_houseAlarm.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Turns house alarm on.
*/
private ["_pos","_house"];
_house = param [0,objNull,[objNull]];
_pos = getPosASL _house;

if (_house getVariable ["alarm",false]) exitWith {};
if (!(_house getVariable ["security",false])) exitWith {};

_house setVariable ["alarm",true,true];
_marker = createMarkerLocal [format ["alarm_%1",(_house getVariable "house_id")],_pos];
_marker setMarkerTextLocal format [["alarmMarkerText"] call cat_alarm_fnc_getText];
_marker setMarkerColorLocal "ColorRed";
_marker setMarkerTypeLocal "loc_Lighthouse";

hint format [(["alarmMessage"] call cat_alarm_fnc_getText),(getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName")),(mapGridPosition _house)];

while {(_house getVariable ["alarm",false])} do {
	playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", _house, false, _pos, 1, 1, 150];
	sleep 5;
};