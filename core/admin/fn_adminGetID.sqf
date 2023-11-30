#include "..\..\script_macros.hpp"
/*
    File: fn_adminGetID.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Ruft die ausgewählte ID des Spielers ab.
    Wird von In-Game-Admins verwendet, um Bans/Kicks durchzuführen.
    https://community.bistudio.com/wiki/Multiplayer_Server_Commands
*/

// Holen Sie sich die ausgewählte Einheit aus dem Dropdown-Menü
private _unit = lbData[2902, lbCurSel (2902)];
_unit = call compile format ["%1", _unit];

// Überprüfen Sie, ob die Einheit gültig ist
if (isNil "_unit" || {isNull _unit}) exitWith {};

// Rufen Sie die Funktion zum Abrufen der ID auf
[_unit, player] remoteExecCall ["TON_fnc_getID", 2];
