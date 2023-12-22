/*
    File: fn_updateHouseContainers.sqf
    Author: NiiRoZz

    Description:
    Update inventory of container.

    This file is for Nanou's HeadlessClient.
*/

params [
    ["_container", objNull, [objNull]]
];

// Exit if the container is null
if (isNull _container) exitWith {};

// Get the container ID
private _containerID = _container getVariable ["container_id", -1];

// Exit if the container doesn't have an ID
if (_containerID isEqualTo -1) exitWith {};

// Retrieve the current cargo of the container
private _vehItems = getItemCargo _container;
private _vehMags = getMagazineCargo _container;
private _vehWeapons = getWeaponCargo _container;
private _vehBackpacks = getBackpackCargo _container;

// Combine cargo arrays into a single array
private _cargo = [_vehItems, _vehMags, _vehWeapons, _vehBackpacks];

// Create the update query
private _query = format ["updateContainer:%1:%2", _cargo, _containerID];

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;
