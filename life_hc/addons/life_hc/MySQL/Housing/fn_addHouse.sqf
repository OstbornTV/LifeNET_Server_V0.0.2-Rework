#include "\life_hc\hc_macros.hpp"

/*
    File: fn_addHouse.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Inserts the player's newly bought house into the database.
*/

params [
    ["_uid", "", [""]],
    ["_house", objNull, [objNull]]
];

// Exit if the house is null or the UID is empty
if (isNull _house || {_uid isEqualTo ""}) exitWith {"Error: Invalid parameters."};

// Get house position
private _housePos = getPosATL _house;

// Insert house into the database
private _query = format ["insertHouse:%1:%2", _uid, _housePos];
if (EXTDB_SETTING(getNumber, "DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1", _query];
};

[_query, 1] call HC_fnc_asyncCall;

// Wait for a short duration to ensure the database has processed the insertion
uiSleep 0.3;

// Retrieve the house ID from the database
_query = format ["selectHouseID:%1:%2", _housePos, _uid];
_queryResult = [_query, 2] call HC_fnc_asyncCall;

// Set the house_id variable on the house object
_house setVariable ["house_id", _queryResult select 0, true];
