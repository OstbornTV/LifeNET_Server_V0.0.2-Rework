#include "..\..\script_macros.hpp"
/*
    File: fn_lockHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Unlocks / locks the house.
*/

// Übergebener Parameter: _house (Hausobjekt)
private ["_house"];
_house = param [0, objNull, [objNull]];

// Überprüfe, ob das übergebene Objekt gültig ist und ein Haus ist
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};

// Ermittle den aktuellen Zustand des Hauses (verschlossen/entriegelt)
_state = _house getVariable ["locked", true];

// Ändere den Zustand des Hauses und zeige eine entsprechende Meldung an
if (_state) then {
    _house setVariable ["locked", false, true]; // Entsperre das Haus
    titleText[localize "STR_House_StorageUnlock", "PLAIN"]; // Zeige Meldung an
} else {
    _house setVariable ["locked", true, true]; // Sperre das Haus
    titleText[localize "STR_House_StorageLock", "PLAIN"]; // Zeige Meldung an
};
