#include "..\..\script_macros.hpp"
/*
    File: fn_corpse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Hides dead bodies.
*/

params [
    ["_corpse", objNull, [objNull]]
];

// Beenden Sie das Skript, wenn die Leiche ungültig ist
if (isNull _corpse) exitWith {};

// Löschen Sie das Fahrzeug (Leiche)
deleteVehicle _corpse;