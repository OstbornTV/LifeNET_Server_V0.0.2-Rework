#include "..\..\script_macros.hpp"
/*
    File: fn_jumpFnc.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Makes the target jump.
*/

params [
    ["_unit", objNull, [objNull]]
];

// Beenden Sie das Skript, wenn die Einheit ungültig ist
if (isNull _unit) exitWith {};
// Beenden Sie das Skript, wenn sich die Einheit bereits im Sprungzustand befindet
if (animationState _unit == "AovrPercMrunSrasWrflDf") exitWith {};

// Speichern der alten Position der Einheit
private _oldPos = getPosATL _unit;

// Wenn die Einheit lokal ist, dann...
if (local _unit) then {
    // Geschwindigkeitswerte für den Sprung
    private _v1 = 3.82;
    private _v2 = .4;
    private _dir = direction _unit;
    (velocity _unit) params ["_xVel","_yVel","_zVel"];
    // Setzen der Geschwindigkeit mit Richtungskomponenten
    _unit setVelocity [_xVel + (sin _dir*_v2), _yVel + (cos _dir*_v2), _zVel + _v1];
};

// Speichern des aktuellen Animationszustands der Einheit
private _anim = animationState _unit;
// Einheit in den Sprungzustand versetzen
_unit switchMove "AovrPercMrunSrasWrflDf";

// Wenn die Einheit lokal ist, dann...
if (local _unit) then {
    // Warten, bis die Einheit auf eine ausreichende Höhe springt
    waitUntil {
        if ((getPos _unit select 2) > 4) then {
            // Setzen der Einheit auf die alte Position
            _unit setPosATL _oldPos;
            // Setzen der Geschwindigkeit auf Null
            _unit setVelocity [0, 0, 0];
        };
        // Überprüfen, ob sich die Einheit nicht mehr im Sprungzustand befindet
        animationState _unit != "AovrPercMrunSrasWrflDf"
    };
    // Einheit zurück in den vorherigen Animationszustand versetzen
    _unit switchMove _anim;
};