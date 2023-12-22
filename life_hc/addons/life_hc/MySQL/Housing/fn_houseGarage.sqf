#include "\life_hc\hc_macros.hpp"

/*
    File: fn_houseGarage.sqf
    Author: BoGuu
    Description: Database functionality for house garages - HC
*/

params [
    ["_uid", "", [""]],
    ["_house", objNull, [objNull]],
    ["_mode", -1, [0]]
];

// Exit if UID, house, or mode is invalid
if (_uid isEqualTo "" || {isNull _house} || {_mode isEqualTo -1}) exitWith {};

// Get the position of the house
private _housePos = getPosATL _house;

// Determine if the garage is active based on the mode
private _active = ["0", "1"] select (_mode isEqualTo 0);

// Create the query to update the garage status in the database
private _query = format ["updateGarage:%1:%2:%3", _active, _uid, _housePos];

// Execute the asynchronous database call
[_query, 1] call HC_fnc_asyncCall;
