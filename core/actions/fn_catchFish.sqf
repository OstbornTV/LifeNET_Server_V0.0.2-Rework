#include "..\..\script_macros.hpp"
/*
    File: fn_catchFish.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Catches a fish that is nearby.
*/
params [
    ["_fish", objNull, [objNull]]
];

// Check if the fish is null or the distance to the fish is more than 3.5 meters
if (isNull _fish || {player distance _fish > 3.5}) exitWith {};

// Set Fish Information
private _fishInfo = switch typeOf _fish do {
    case "Salema_F": {["STR_ANIM_Salema", "salema_raw"]};
    case "Ornate_random_F": {["STR_ANIM_Ornate", "ornate_raw"]};
    case "Mackerel_F": {["STR_ANIM_Mackerel", "mackerel_raw"]};
    case "Tuna_F": {["STR_ANIM_Tuna", "tuna_raw"]};
    case "Mullet_F": {["STR_ANIM_Mullet", "mullet_raw"]};
    case "CatShark_F": {["STR_ANIM_Catshark", "catshark_raw"]};
    case "Turtle_F": {["STR_ANIM_Turtle", "turtle_raw"]};
    default {["", ""]};
};

// Sort out array
_fishInfo params ["_fishName", "_fishType"];

// Check if fishtype is empty
if (_fishType isEqualTo "") exitWith {};

// Localize name of fish
private _fishName = localize _fishName;

// Add fish into inventory
if ([true, _fishType, 1] call life_fnc_handleInv) then {
    // Delete fish in water
    deleteVehicle _fish;

    titleText [format [localize "STR_NOTF_Fishing", _fishName], "PLAIN"];
};
