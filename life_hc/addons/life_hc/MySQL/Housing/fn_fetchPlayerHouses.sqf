#include "\life_hc\hc_macros.hpp"

/*
    File: fn_fetchPlayerHouses.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    1. Fetches all the players' houses and sets them up.
    2. Fetches all the players' containers and sets them up.
*/

params [
    ["_uid", "", [""]]
];

// Exit if the UID is empty
if (_uid isEqualTo "") exitWith {};

// Fetch containers for the player
private _query = format ["selectContainers:%1", _uid];
private _containers = [_query, 2, true] call HC_fnc_asyncCall;

// Array to store created containers
private _containerss = [];

{
    // Extract information from the container data
    _position = call compile format ["%1", _x select 1];
    _house = nearestObject [_position, "House"];
    _direction = call compile format ["%1", _x select 5];
    _trunk = _x select 3;

    // Handle cases where _trunk is not a string
    if (_trunk isEqualType "") then {_trunk = call compile format ["%1", _trunk];};

    _gear = _x select 4;

    // Create the container
    _container = createVehicle [_x select 2, [0, 0, 999], [], 0, "NONE"];
    waitUntil {!isNil "_container" && {!isNull _container}};

    // Update containerss array
    _containerss = _house getVariable ["containers", []];
    _containerss pushBack _container;

    // Set container properties
    _container allowDamage false;
    _container setPosATL _position;
    _container setVectorDirAndUp _direction;

    // Fix position for more accurate positioning
    _currentPos = getPosATL _container;
    _container setPosATL [_position select 0, _position select 1, _currentPos select 2];

    _container setVectorDirAndUp _direction;
    _container setVariable ["Trunk", _trunk, true];
    _container setVariable ["container_owner", [_x select 0], true];
    _container setVariable ["container_id", _x select 6, true];

    // Clear container cargo
    clearWeaponCargoGlobal _container;
    clearItemCargoGlobal _container;
    clearMagazineCargoGlobal _container;
    clearBackpackCargoGlobal _container;

    // Load gear into the container
    if (count _gear > 0) then {
        _items = _gear select 0;
        _mags = _gear select 1;
        _weapons = _gear select 2;
        _backpacks = _gear select 3;

        // Add items
        for "_i" from 0 to ((count (_items select 0)) - 1) do {
            _container addItemCargoGlobal [(_items select 0) select _i, (_items select 1) select _i];
        };

        // Add magazines
        for "_i" from 0 to ((count (_mags select 0)) - 1) do {
            _container addMagazineCargoGlobal [(_mags select 0) select _i, (_mags select 1) select _i];
        };

        // Add weapons
        for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
            _container addWeaponCargoGlobal [(_weapons select 0) select _i, (_weapons select 1) select _i];
        };

        // Add backpacks
        for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
            _container addBackpackCargoGlobal [(_backpacks select 0) select _i, (_backpacks select 1) select _i];
        };
    }

    // Update house variable
    _house setVariable ["containers", _containerss, true];
} forEach _containers;

// Fetch house positions for the player
_query = format ["selectHousePositions:%1", _uid];
private _houses = [_query, 2, true] call HC_fnc_asyncCall;

// Array to store house positions
_return = [];
{
    // Extract house position information
    _pos = call compile format ["%1", _x select 1];
    _house = nearestObject [_pos, "House"];

    // Set house properties
    _house allowDamage false;
    _return pushBack [_pos];
} forEach _houses;

// Update missionNamespace variable with house positions
missionNamespace setVariable [format ["houses_%1", _uid], _return];
