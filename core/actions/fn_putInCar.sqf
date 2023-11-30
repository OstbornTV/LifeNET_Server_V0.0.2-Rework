#include "..\..\script_macros.hpp"
/*
    File: fn_putInCar.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Finds the nearest vehicle and loads the target into the vehicle.
*/
params [
    ["_unit", objNull, [objNull]]
];

// Überprüfen Sie, ob die Einheit ungültig ist oder kein Spieler ist
if (isNull _unit || {!isPlayer _unit}) exitWith {};

// Holen Sie sich das nächstgelegene Fahrzeug innerhalb von 10 Metern
(nearestObjects[getPosATL player, ["Car","Ship","Submarine","Air"], 10]) params [["_nearestVehicle", objNull, [objNull]]];
// Überprüfen Sie, ob kein Fahrzeug gefunden wurde
if (isNull _nearestVehicle) exitWith {
    hint localize "STR_NOTF_VehicleNear";
};

// Lösen Sie die Einheit von ihrem aktuellen Ort
detach _unit;
// Führen Sie die Remote-Execution-Funktion "life_fnc_moveIn" für das Fahrzeug aus
[_nearestVehicle] remoteExecCall ["life_fnc_moveIn", _unit];
// Setzen Sie die Variablen "Escorting" und "transporting" auf false
_unit setVariable ["Escorting", false, true];
_unit setVariable ["transporting", true, true];
