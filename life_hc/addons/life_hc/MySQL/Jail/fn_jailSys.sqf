#include "\life_hc\hc_macros.hpp"

/*
    File: fn_jailSys.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    I forget?
*/

// Private variables
private ["_unit", "_bad", "_ret"];

// Get the unit from the function parameters
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Exit if the unit is null
if (isNull _unit) exitWith {};

// Get the "bad" parameter from the function parameters
_bad = [_this, 1, false, [false]] call BIS_fnc_param;

// Call the HC_fnc_wantedPerson function to determine if the unit is wanted
_ret = [_unit] call HC_fnc_wantedPerson;

// Execute the life_fnc_jailMe function on the unit with the result and "bad" parameter
[_ret, _bad] remoteExec ["life_fnc_jailMe", _unit];
