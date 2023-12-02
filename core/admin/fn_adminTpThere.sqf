#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpThere.sqf
    Author: ColinM9991
    
    Description:
    Teleports the selected player to you.
*/

// Überprüft das Admin-Level für die Ausführung dieser Aktion
if (FETCH_CONST(life_adminlevel) < 1) exitWith {closeDialog 0;};

private ["_target", "_messagelog"];

// Holt den ausgewählten Spieler aus der Liste
_target = lbData[2902, lbCurSel(2902)];
_target = call compile format ["%1", _target];

// Überprüft, ob der ausgewählte Spieler gültig ist
if (isNil "_target") exitWith {};
if (_target isEqualTo player) exitWith {hint localize "STR_ANOTF_Error";};

// Überprüft, ob der ausgewählte Spieler sich in einem Fahrzeug befindet
if (_target != vehicle _target) then
{
    // Teleportiert den Spieler in das Fahrzeug des ausgewählten Spielers
    player moveInAny (vehicle _target);
    _messagelog = format ["ADMIN: Du hast dich zu %1 ins Fahrzeug geportet", _target getVariable ["realname", name _target]];
}
else
{
    // Teleportiert den Spieler zu der Position des ausgewählten Spielers
    private _pos = getPosATL _target;
    player setPosATL [_pos param [0], _pos param [1], (_pos param [2]) + 0.5];
    _messagelog = format ["ADMIN: Du hast dich zu %1 geportet", _target getVariable ["realname", name _target]];
};
