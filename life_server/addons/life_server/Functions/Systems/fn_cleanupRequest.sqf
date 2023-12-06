/*
    File: fn_cleanupRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Client sends a cleanup request when they hit Abort,
    the server will then monitor when that client aborts and
    delete the weapon holders.
*/
private ["_client", "_loops"];
_client = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _client) exitWith {};

_loops = 0;
while {_loops < 25 && alive _client} do {
    _loops = _loops + 1;
    uiSleep 1;
};

// Check if the client is no longer alive
if (!alive _client) then {
    _containers = nearestObjects [(getPosATL _client), ["WeaponHolderSimulated"], 5];
    if (count _containers > 0) then {
        { deleteVehicle _x; } forEach _containers; // Delete the containers.
    };
    deleteVehicle _client; // Get rid of the corpse.
};
