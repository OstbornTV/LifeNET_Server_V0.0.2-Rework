#include "..\..\script_macros.hpp"
/*
    File: fn_spikeStripEffect.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Pops all tires of the vehicle and affects the vehicle behavior.
*/

params [
    ["_vehicle",objNull,[objNull]] // Parameter: _vehicle (Fahrzeug), Standardwert: objNull (kein Objekt)
];

// Wenn das Fahrzeug nicht vorhanden ist, beende die Ausführung des Skripts.
if (isNull _vehicle) exitWith {};

// Status der Reifen aktualisieren
private _damagedWheels = _vehicle getVariable ["damagedWheels", []];
_damagedWheels pushBack "HitLFWheel";
_damagedWheels pushBack "HitRFWheel";
_vehicle setVariable ["damagedWheels", _damagedWheels, true];

// Reparaturoptionen prüfen
if (count _damagedWheels > 2) then {
    // Wenn mehr als zwei Reifen beschädigt sind, Steuerung einschränken
    _vehicle allowCrewInImmobile true; // Erlaubt Besatzung, in einem immobilisierten Fahrzeug zu sitzen
    _vehicle enableSimulation false; // Deaktiviert die Simulation des Fahrzeugs
} else {
    // Wenn zwei oder weniger Reifen beschädigt sind, Steuerung beibehalten
    _vehicle allowCrewInImmobile false;
    _vehicle enableSimulation true;
};

// Visuelle Effekte für beschädigte Reifen hinzufügen (Beispiel: Rauch)
{
    if (_vehicle getHitPointDamage _x > 0.5) then {
        _vehicle animateSource [_x, 1];
    };
} forEach _damagedWheels;

// Reparaturoptionen hinzufügen
if (count _damagedWheels > 0) then {
    // Spieler in der Nähe über Reparaturoptionen informieren (Beispiel: Action Menu)
    [_vehicle] remoteExec ["life_fnc_showRepairOptions", -2];
};

// Durchlaufe alle Räder des Fahrzeugs und setze den Schaden auf 1.
{
    _vehicle setHitPointDamage [_x, 1];
} forEach allHitPointsDamage _vehicle;

// Rufe das Skript auf, das das Fahrverhalten beeinflusst.
[_vehicle] remoteExecCall ["life_fnc_changeVehicleBehavior", RSERVER];
