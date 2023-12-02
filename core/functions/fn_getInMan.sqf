#include "..\..\script_macros.hpp"
/*
    File: fn_getInMan.sqf
    Author: blackfisch
    Description:
    Behandelt das Einsteigen des Spielers in ein Fahrzeug.
*/
params [
    ["_unit", objNull, [objNull]],    // Spielerobjekt, Standardobjekt ist null
    ["_role", "", [""]],               // Rolle des Spielers im Fahrzeug, Standard ist ein leerer String
    ["_vehicle", objNull, [objNull]],  // Fahrzeugobjekt, Standardobjekt ist null
    ["_turret", [], [[]]]              // Informationen über das Geschütz des Fahrzeugs, Standard ist ein leeres Array
];

// Aktualisiere die Einstellungen zur Sichtweite
[] call life_fnc_updateViewDistance;
