#include "..\..\script_macros.hpp"
/*
    File: showRepairOptions.sqf
    Author: OsbornTV
    Description:

*/

params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {};

// Funktion für das Action-Menü anzeigen
player addAction ["Reparieren", {
    // Hier können spezifische Reparaturoptionen implementiert werden
    // Beispiel: [_vehicle] remoteExec ["life_fnc_repairVehicle", -2];
}, [], 0, false, true, "", "vehicle _this == _target"];