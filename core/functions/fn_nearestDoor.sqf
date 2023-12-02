/*
    File: fn_nearestDoor.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Holt die nächstgelegene Tür des Gebäudes, auf das der Spieler schaut.
*/
private ["_house","_door","_numOfDoors"];

// Parameter überprüfen und initialisieren
_house = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
if (isNull _house) exitWith {0};
if (!(_house isKindOf "House_F")) exitWith {0};

_door = 0;

// Anzahl der Türen im Gebäude abrufen
_doors = getNumber(configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");

// Schleife durch alle Türen des Gebäudes
for "_i" from 1 to _doors do {
    // Position der Tür-Auslösung (trigger) abrufen
    _selectionPos = _house selectionPosition format ["Door_%1_trigger", _i];

    // Weltkoordinaten der Türposition berechnen
    _worldSpace = _house modelToWorld _selectionPos;

    // Überprüfen, ob der Spieler in der Nähe der Tür ist
    if (player distance _worldSpace < 2.4) exitWith {_door = _i};
};

// Rückgabe der Türnummer
_door;
