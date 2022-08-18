#include "..\..\script_macros.hpp"
/*
    File: fn_sirenLights.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Lets play a game! Can you guess what it does? I have faith in you, if you can't
    then you have failed me and therefor I lose all faith in humanity.. No pressure.
*/
params [
    ["_vehicle",objNull,[objNull]]
];

if (isNull _vehicle) exitWith {};
if !(typeOf _vehicle in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F","C_Hatchback_01_sport_F","B_Heli_Light_01_F","B_Heli_Transport_01_F"]) exitWith {};

private _lightsOn = _vehicle getVariable ["lights",false];

if (!_lightsOn) then {
    [_vehicle,0.22] remoteExec ["life_fnc_copLights",RCLIENT];
};

_vehicle setVariable ["lights", !_lightsOn, true]; 