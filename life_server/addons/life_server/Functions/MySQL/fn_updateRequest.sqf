/*
    File: fn_updateRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Updates ALL player information in the database.
    Information gets passed here from the client side file: core\session\fn_updateRequest.sqf
*/

params [
    ["_uid", "", [""]],
    ["_name", "", [""]],
    ["_side", sideUnknown, [civilian]],
    ["_cash", 0, [0]],
    ["_bank", 5000, [0]],
    ["_licenses", [], [[]]],
    ["_gear", [], [[]]],
    ["_stats", [100, 100], [[]]],
    ["_arrested", false, [true]],
    ["_alive", false, [true]],
    ["_position", [], [[]]]
];

// Get to those error checks.
if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith {};

// Setup some data.
_position = if (_side isEqualTo civilian) then {_position} else {[]};
_arrested = [0, 1] select _arrested;
_alive = [0, 1] select _alive;

// Does something license related but I can't remember I only know it's important?
{
    params ["_license", "_owned"];
    _licenses set[_forEachIndex, [_license, [0, 1] select _owned]];
} forEach _licenses;

// PLAYTIME
_playtime = [_uid] call TON_fnc_getPlayTime;
_playtime_update = _playtime;

{
    if ((_x select 0) isEqualTo _uid) then {
        _playtime_update = [_playtime, (_x select 1) select 0, (_x select 2) select 2];
        exitWith {};
    };
} forEach TON_fnc_playtime_values_request;

private _query = switch (_side) do {
    case west: {format ["updateWest:%1:%2:%3:%4:%5:%6:%7:%8", _name, _cash, _bank, _gear, _licenses, _stats, _playtime_update, _uid];};
    case civilian: {format ["updateCiv:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11", _name, _cash, _bank, _licenses, _gear, _arrested, _stats, _alive, _position, _playtime_update, _uid];};
    case independent: {format ["updateIndep:%1:%2:%3:%4:%5:%6:%7:%8", _name, _cash, _bank, _licenses, _gear, _stats, _playtime_update, _uid];};
};

_queryResult = [_query, 1] call DB_fnc_asyncCall;
