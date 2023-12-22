#include "\life_hc\hc_macros.hpp"

/*
    File: fn_addContainer.sqf
    Author: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    Add container in Database.
*/

params [
    ["_uid", "", [""]],
    ["_container", objNull, [objNull]]
];

// Exit if the container is null or the UID is empty
if (isNull _container || {_uid isEqualTo ""}) exitWith {"Error: Invalid parameters."};

// Get container position, class name, and direction
private _containerPos = getPosATL _container;
private _className = typeOf _container;
private _dir = [vectorDir _container, vectorUp _container];

// Insert container into the database
private _query = format ["insertContainer:%1:%2:%3:%4", _uid, _containerPos, _className, _dir];
[_query, 1] call HC_fnc_asyncCall;

// Wait for a short duration to ensure the database has processed the insertion
uiSleep 0.3;

// Retrieve the container ID from the database
_query = format ["selectContainerID:%1:%2", _containerPos, _uid];
_queryResult = [_query, 2] call HC_fnc_asyncCall;

// Set the container_id variable on the container object
_container setVariable ["container_id", _queryResult select 0, true];
