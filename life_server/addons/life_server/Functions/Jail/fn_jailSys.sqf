#include "\life_server\script_macros.hpp"
/*
    File: fn_jailSys.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Ich erinnere mich nicht?
*/
private ["_unit", "_bad", "_id", "_ret"];

// Erhalte das Einheitenobjekt aus den Funktionsparametern
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Beende die Ausführung, wenn die Einheit ungültig ist
if (isNull _unit) exitWith {};

// Erhalte den "bad" Parameter aus den Funktionsparametern
_bad = [_this, 1, false, [false]] call BIS_fnc_param;

// Erhalte die Einheiten-ID des Besitzers
_id = owner _unit;

// Rufe die Funktion wantedPerson auf und speichere das Ergebnis
_ret = [_unit] call life_fnc_wantedPerson;

// Rufe die Funktion jailMe asynchron für den Einheitenbesitzer auf
[_ret, _bad] remoteExec ["life_fnc_jailMe", _id];
