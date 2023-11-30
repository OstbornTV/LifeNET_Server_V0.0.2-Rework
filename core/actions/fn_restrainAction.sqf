#include "..\..\script_macros.hpp"
/*
    File: fn_restrainAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Restrains the target.
*/

// Holen Sie sich das aktuelle Ziel unter dem Cursor des Spielers
private _unit = cursorObject;

// Überprüfen Sie die Bedingungen für die Anwendung von Handschellen
if (isNull _unit) exitWith {};
if (player distance _unit > 3) exitWith {};
if (_unit getVariable "restrained") exitWith {};
if (side _unit isEqualTo west) exitWith {};
if (player isEqualTo _unit) exitWith {};
if (!isPlayer _unit) exitWith {};

// Rundfunk!
_unit setVariable ["playerSurrender", false, true];
_unit setVariable ["restrained", true, true];

// Rufen Sie die restrain-Funktion auf dem Server auf und übermitteln Sie das Ziel
[player] remoteExec ["life_fnc_restrain", _unit];

// Senden Sie eine Rundfunknachricht an die westliche Seite
[0, "STR_NOTF_Restrained", true, [_unit getVariable ["realname", name _unit], profileName]] remoteExecCall ["life_fnc_broadcast", west];
