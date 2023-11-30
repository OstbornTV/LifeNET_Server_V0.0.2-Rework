#include "..\..\script_macros.hpp"
/*
    File: fn_robAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Starts the robbing process?
*/

// Holen Sie sich das aktuelle Ziel unter dem Cursor des Spielers
private ["_target"];
_target = cursorObject;

// Überprüfen Sie die Fehlerbedingungen
if (isNull _target) exitWith {};
if (!isPlayer _target) exitWith {};

// Überprüfen, ob die Person bereits beraubt wurde
if (_target getVariable ["robbed", false]) exitWith {};

// Rufen Sie die robPerson-Funktion auf dem Server auf und übermitteln Sie das Ziel
[player] remoteExecCall ["life_fnc_robPerson", _target];

// Markieren Sie die Person als beraubt
_target setVariable ["robbed", true, true];
