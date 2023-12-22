/*
    File: fn_deleteDBContainer.sqf
    Author: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    Delete Container and remove Container from the Database
*/

params [
    ["_container", objNull, [objNull]]
];

// Exit if the container is null
if (isNull _container) exitWith {diag_log "Container is null";};

// Get container ID from the variable
_containerID = _container getVariable ["container_id", -1];

private "_query";

// Check if the container has an ID, if not, delete based on position
if (_containerID isEqualTo -1) then {
    _containerPos = getPosATL _container;
    private _ownerID = (_container getVariable "container_owner") select 0;
    _query = format ["deleteContainer:%1:%2", _ownerID, _containerPos];
} else {
    // Delete based on container ID
    _query = format ["deleteContainer1:%1", _containerID];
};

// Clear container variables
_container setVariable ["container_id", nil, true];
_container setVariable ["container_owner", nil, true];

// Asynchronously remove the container from the database
[_query, 1] call HC_fnc_asyncCall;

// Asynchronously trigger the removal of old containers
["deleteOldContainers", 1] call HC_fnc_asyncCall;

// Delete the container in the game world
deleteVehicle _container;
