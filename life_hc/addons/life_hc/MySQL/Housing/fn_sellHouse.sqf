/*
    File: fn_sellHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Used in selling the house, sets the owned status to 0 and will cleanup with a
    stored procedure on restart.
*/

params [
    ["_house", objNull, [objNull]]
];

// Exit if the house is null
if (isNull _house) exitWith { systemChat ":SERVER:sellHouse: House is null"; };

// Get the house ID
private _houseID = _house getVariable ["house_id", -1];

private "_query";

// Determine the appropriate query based on whether the house has an ID
if (_houseID isEqualTo -1) then {
    // House doesn't have an ID, use position and owner ID to delete
    private _housePos = getPosATL _house;
    private _ownerID = (_house getVariable "house_owner") select 0;
    _query = format ["deleteHouse:%1:%2", _ownerID, _housePos];
} else {
    // House has an ID, use the ID to delete
    _query = format ["deleteHouse1:%1", _houseID];
};

// Clear house variables
_house setVariable ["house_id", nil, true];
_house setVariable ["house_owner", nil, true];
_house setVariable ["garageBought", false, true];

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;

// Set house_sold variable to nil and delete old houses
_house setVariable ["house_sold", nil, true];
["deleteOldHouses", 1] call HC_fnc_asyncCall;
