/*
    File: fn_houseAlarmBuy.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)
    
    Description:
    Buy security system for your house.
*/
private ["_action","_price","_house"];
_house = param [0,objNull,[objNull]];
_price = getNumber(missionConfigFile >> "Cation_Alarm" >> "price");
closeDialog 0;

if (_house getVariable ["security",false]) exitWith {hint format [["securityAlreadyInstalled"] call cat_alarm_fnc_getText];};

_action = [
    format [(["securityInstall"] call cat_alarm_fnc_getText),_price],
    (["securitySystem"] call cat_alarm_fnc_getText),
    (["buy"] call cat_alarm_fnc_getText),
    (["cancel"] call cat_alarm_fnc_getText)
] call BIS_fnc_guiMessage;

if (_action) then {
    if (life_cash < _price) exitWith {hint format [["NotEnoughMoney"] call cat_alarm_fnc_getText];};
    life_cash = life_cash - _price;
    if (getNumber(missionConfigFile >> "Cation_Alarm" >> "HeadlessSupport") isEqualTo 0) then {
        [(getPlayerUID player),_house] remoteExec ["cat_alarm_fnc_addSecurity",2];
    } else {
        if (life_HC_isActive) then {
            [(getPlayerUID player),_house] remoteExec ["cat_alarm_fnc_addSecurityHC",HC_Life];
        } else {
            [(getPlayerUID player),_house] remoteExec ["cat_alarm_fnc_addSecurity",2];
        };
    };
        
    _marker = createMarkerLocal [format ["house_%1",(_house getVariable "house_id")],(getPosATL _house)];
    _marker setMarkerTextLocal format["%1 [%2]",getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName"),(["secured"] call cat_alarm_fnc_getText)];
    _marker setMarkerColorLocal "ColorBlue";
    _marker setMarkerTypeLocal "loc_Lighthouse";
};