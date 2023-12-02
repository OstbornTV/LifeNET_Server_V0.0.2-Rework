#include "..\..\script_macros.hpp"
/*
    File: fn_lockupHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Locks up the entire house and closes all doors.
*/

// Übergebener Parameter: _house (Hausobjekt)
private ["_house"];
_house = param [0, objNull, [objNull]];

// Überprüfe, ob das übergebene Objekt gültig ist und ein Haus ist
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};

// Ermittle die Anzahl der Türen im Haus
_numberOfDoors = FETCH_CONFIG2(getNumber, "CfgVehicles", (typeOf _house), "numberOfDoors");

// Wenn die Anzahl der Türen ungültig oder 0 ist, beende die Ausführung
if (_numberOfDoors isEqualTo -1 || _numberOfDoors isEqualTo 0) exitWith {};

// Zeige eine Meldung an und warte für 3 Sekunden
titleText [localize "STR_House_LockingUp", "PLAIN"];
sleep 3;

// Schließe alle Türen im Haus
for "_i" from 1 to _numberOfDoors do {
    _house animateSource [format ["Door_%1_source", _i], 0]; // Schließe die Tür
    _house setVariable [format ["bis_disabled_Door_%1", _i], 1, true]; // Deaktiviere die Tür
};

// Sperre das gesamte Haus
_house setVariable ["locked", true, true];

// Zeige eine Meldung an, dass das Haus verschlossen wurde
titleText [localize "STR_House_LockedUp", "PLAIN"];
