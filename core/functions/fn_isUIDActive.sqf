#include "..\..\script_macros.hpp"
/*
    File: fn_isUIDActive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sees if the UID passed to it is in the server.

    Returns:
    True if there was a match, false if not in server.
*/
private ["_uid","_ret"];
// Extrahiert den ersten Parameter (_uid) aus dem Funktionsaufruf und setzt einen Standardwert von ""
_uid = [_this,0,"",[""]] call BIS_fnc_param;
// Wenn die UID leer ist, wird mit false beendet (ungültige UID)
if (_uid isEqualTo "") exitWith {false};
// Setzt den Standardwert von _ret auf false
_ret = false;
// Durchläuft alle spielbaren Einheiten auf dem Server
{
    // Überprüft, ob die Einheit ein Spieler ist und die UID übereinstimmt
    if (isPlayer _x && {getPlayerUID _x isEqualTo _uid}) exitWith {_ret = true;};
} forEach playableUnits;

// Gibt den Wert von _ret zurück (true, wenn die UID aktiv ist, andernfalls false)
_ret;
