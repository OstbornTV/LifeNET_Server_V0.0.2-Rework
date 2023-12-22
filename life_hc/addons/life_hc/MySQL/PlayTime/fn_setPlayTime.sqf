/*
    File: fn_setPlayTime.sqf
    Author: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    Sets gathered time of player

    GATHERED - Loaded from DB and NOT changed
    JOIN - Time, the player joined - the newly gathered playtime will be calculated using difference
*/

private ["_uid", "_time_gathered"];

// Extract parameters from the function call
_uid = _this select 0;
_time_gathered = ((_this select 1) * 60); // Convert minutes to seconds

// Call HC_fnc_getPlayTime to create the value using get
[_uid] call HC_fnc_getPlayTime;

// Set the gathered time for the player
{
    if ((_x select 0) isEqualTo _uid) exitWith {
        _x set [1, _time_gathered]; // Set gathered time
        _x set [2, time]; // Set the current time as the join time
    };
} forEach TON_fnc_playtime_values;
