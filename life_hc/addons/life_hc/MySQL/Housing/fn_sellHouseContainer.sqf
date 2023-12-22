/*
    File: fn_sellHouseContainer.sqf
    Author: NiiRoZz

    Description:
    Used in selling the house; container sets the ownership to 0 and will be cleaned up with a
    stored procedure on restart.
*/

params [
    ["_container", objNull, [objNull]]
];

// Exit if the container is null
if (isNull _container) exitWith {};

// Get the container ID
_containerID = _container getVariable ["container_id", -1];

private "_query";

// Determine the appropriate query based on whether the container has an ID
if (_containerID isEqualTo -1) then {
    // Container doesn't have an ID, use position and owner ID to delete
    _containerPos = getPosATL _container;
    private _ownerID = (_container getVariable "container_owner") select 0;
    _query = format ["deleteContainer:%1:%2", _ownerID, _containerPos];
} else {
    // Container has an ID, use the ID to delete
    _query = format ["deleteContainer1:%1", _containerID];
};

// Clear container variables and delete the container
_container setVariable ["container_id", nil, true];
_container setVariable ["container_owner", nil, true];
deleteVehicle _container;

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;

// Delete old containers
["deleteOldContainers", 1] call HC_fnc_asyncCall;
