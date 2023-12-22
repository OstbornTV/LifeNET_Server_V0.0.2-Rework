/*
    File: fn_updateHouseTrunk.sqf
    Author: NiiRoZz

    Description:
    Update inventory "y" in container.

    This file is for Nanou's HeadlessClient.
*/

params [
    ["_container", objNull, [objNull]]
];

// Exit if the container is null
if (isNull _container) exitWith {};

// Retrieve trunk data and container ID
private _trunkData = _container getVariable ["Trunk", [[], 0]];
private _containerID = _container getVariable ["container_id", -1];

// Exit if the container doesn't have an ID
if (_containerID isEqualTo -1) exitWith {};

// Create the update query
private _query = format ["updateHouseTrunk:%1:%2", _trunkData, _containerID];

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;
