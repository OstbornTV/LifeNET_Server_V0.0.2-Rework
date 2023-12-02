#include "..\..\script_macros.hpp"
/*
    File: fn_repairVehicle.sqf
    Author: OsbornTV
    Description:

*/

params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {};

// Hier können spezifische Logik für die Fahrzeugreparatur implementiert werden
_vehicle setDamage 0;

// Zusätzliche visuelle Effekte, Sounds oder Anpassungen können hier hinzugefügt werden

// Optional: Informiere alle Spieler über die durchgeführte Reparatur
["STR_Vehicle_Repaired", _vehicle] remoteExec ["life_fnc_broadcast", -2];
