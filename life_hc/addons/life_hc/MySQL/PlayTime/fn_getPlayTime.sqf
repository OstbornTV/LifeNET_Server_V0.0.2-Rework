/*
    File: fn_getPlayTime.sqf
    Author: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    Gets playtime for player with UID

    GATHERED - Loaded from DB and NOT changed
    JOIN - Time, the player joined - the newly gathered playtime will be calculated using difference
*/

private ["_uid", "_time_gathered", "_time_join", "_time"];

// Extract parameters from the function call
_uid = _this select 0;
_time_gathered = nil;
_time_join = nil;

// Iterate through TON_fnc_playtime_values array to find player UID
{
    if ((_x select 0) isEqualTo _uid) exitWith {
        _time_gathered = _x select 1;
        _time_join = _x select 2;
    };
} forEach TON_fnc_playtime_values;

// If gathered playtime or join time is not available, initialize with default values
if (isNil "_time_gathered" || isNil "_time_join") then {
    _time_gathered = 0;
    _time_join = time;
    TON_fnc_playtime_values pushBack [_uid, _time_gathered, _time_join];
};

// Update the global variable TON_fnc_playtime_values
publicVariable "TON_fnc_playtime_values";

// Calculate the total playtime in minutes
_time = (time - _time_join); // Calculate the time since the player joined
_time = _time + _time_gathered; // Add the gathered playtime
_time = round (_time/60); // Convert total time to minutes

_time; // Return the calculated playtime
