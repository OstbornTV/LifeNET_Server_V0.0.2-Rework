/*
    File: fn_nearUnits.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Überprüft, ob sich Einheiten in der Nähe befinden (menschliche Einheiten).

    Returns:
    true - Einheiten sind in der Nähe
    false - Keine Einheiten in der Nähe
*/
private ["_faction","_position","_radius","_ret"];

// Parameter überprüfen und initialisieren
_faction = [_this, 0, sideUnknown, [sideUnknown]] call BIS_fnc_param;
_position = [_this, 1, (getPos player), [[]]] call BIS_fnc_param;
_radius = [_this, 2, 30, [0]] call BIS_fnc_param;
_ret = false;

// Fehlerüberprüfung
if (_faction isEqualTo sideUnknown) exitWith {_ret};

// Überprüfen, ob es menschliche Einheiten in der Nähe gibt
_ret = {!(_x isEqualTo player) && side _x isEqualTo _faction && alive _x && _position distance _x < _radius} count playableUnits > 0;

// Rückgabe des Ergebnisses
_ret;
