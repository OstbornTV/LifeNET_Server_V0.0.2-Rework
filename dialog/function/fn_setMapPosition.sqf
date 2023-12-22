#include "..\..\script_macros.hpp"
/*
    File: fn_setMapPosition.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Setzt die gegebene Steuerung / Kartenausrichtung
*/
// Serialisierung deaktivieren
disableSerialization;

// Lokale Variablen deklarieren
private ["_control", "_time", "_zoom", "_position"];

// Parameter extrahieren
// _control: Die zu manipulierende Steuerung, z.B., die Karte
// _time: Dauer der Animation
// _zoom: Zoom-Faktor der Animation
// _position: Neue Position der Karte
_control = [_this, 0, controlNull, [controlNull]] call BIS_fnc_param;
_time = [_this, 1, 1, [0]] call BIS_fnc_param;
_zoom = [_this, 2, 0.1, [0]] call BIS_fnc_param;
_position = [_this, 3, [], [[]]] call BIS_fnc_param;

// Überprüfen, ob die Steuerung gültig ist oder die Position leer ist
if (isNull _control || _position isEqualTo []) exitWith {};

// Animationsinformationen zur Steuerung hinzufügen
_control ctrlMapAnimAdd [_time, _zoom, _position];
// Kartenausrichtung animieren
ctrlMapAnimCommit _control;
