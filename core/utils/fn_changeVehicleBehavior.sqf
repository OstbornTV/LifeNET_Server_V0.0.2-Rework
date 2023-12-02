#include "..\..\script_macros.hpp"
/*
    File: fn_changeVehicleBehavior.sqf
    Author: OsbornTV
    Description:
    Changes the vehicle behavior based on the number of damaged tires.
*/

params [
    ["_vehicle", objNull, [objNull]] // Parameter: _vehicle (Fahrzeug), Standardwert: objNull (kein Objekt)
];

// Wenn das Fahrzeug nicht vorhanden ist, beende die Ausführung des Skripts.
if (isNull _vehicle) exitWith {};

// Zähle die Anzahl der beschädigten Räder.
private _damagedTires = 0;

{
    if (_vehicle getHitPointDamage _x > 0.5) then {
        _damagedTires = _damagedTires + 1;
    };
} forEach ["HitLFWheel", "HitRFWheel", "HitLF2Wheel", "HitRF2Wheel", "HitLMWheel", "HitRMWheel", "HitLBWheel", "HitRBWheel"];

// Ändere das Fahrverhalten basierend auf der Anzahl der beschädigten Räder.
switch (_damagedTires) do {
    case 0: {
        // Kein beschädigter Reifen
        _vehicle setSpeedMode "NORMAL";
        _vehicle setFormation "WEDGE";
        hint "Fahrzeugverhalten: Normales Fahrverhalten";
    };
    case 1: {
        // Ein beschädigter Reifen
        _vehicle setSpeedMode "LIMITED";
        _vehicle setFormation "COLUMN";
        hint "Fahrzeugverhalten: Ein beschädigter Reifen";
    };
    case 2: {
        // Zwei beschädigte Reifen
        _vehicle setSpeedMode "LIMITED";
        _vehicle setFormation "STAG COLUMN";
        hint "Fahrzeugverhalten: Zwei beschädigte Reifen";
    };
    default {
        // Drei oder mehr beschädigte Reifen
        _vehicle setSpeedMode "FULL";
        _vehicle setFormation "FILE";
        hint "Fahrzeugverhalten: Drei oder mehr beschädigte Reifen";
    };
};