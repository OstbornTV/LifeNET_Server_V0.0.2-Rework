/*
    File: fn_setPlayTime.sqf
    Author: NiiRoZz

    Description:
    Sets gathered time of a player.
    GATHERED - Loaded from DB and NOT changed
    JOIN - Time when the player joined - the newly gathered playtime will be calculated using the difference
*/

private ["_uid", "_time_gathered"];

_uid = _this select 0;
_time_gathered = ((_this select 1) * 60);

// Create value using get
[_uid] call TON_fnc_getPlayTime;

// Set value at index 1
{
    if ((_x select 0) isEqualTo _uid) then {
        _x set [1, _time_gathered];
        _x set [2, time];
        exitWith {};
    };
} forEach TON_fnc_playtime_values;
