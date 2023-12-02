#include "..\..\script_macros.hpp"
/*
    Datei: fn_lightHouseAction.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Schaltet das Licht im Haus ein oder aus.
*/

// Übergebene Parameter definieren
private ["_house"];
_house = param [0, objNull, [objNull]];

// Beende das Skript, wenn das übergebene Hausobjekt null oder kein Haus ist.
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};

// Remote-Aufruf der Funktion life_fnc_lightHouse basierend auf dem Lichtstatus des Hauses.
[_house, isNull (_house getVariable ["lightSource", objNull])] remoteExecCall ["life_fnc_lightHouse", RCLIENT];
