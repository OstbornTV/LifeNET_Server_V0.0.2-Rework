#include "..\..\script_macros.hpp"
/*
    File: fn_itemWeight.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gets the item's weight and returns it.
*/

params [
    ["_item", "", [""]]
];

// Sichergehen, dass _item nicht leer ist
_item = [_this, 0, "", [""]] call BIS_fnc_param;
if (_item isEqualTo "") exitWith {};

// Das Gewicht des virtuellen Gegenstands abrufen
M_CONFIG(getNumber, "VirtualItems", _item, "weight");
