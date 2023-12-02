#include "..\..\script_macros.hpp"
/*
    File: fn_adminTpHere.sqf
    Author: ColinM9991
    
    Description:
    Teleports the selected player to you.
*/

// Überprüft das Admin-Level für die Ausführung dieser Aktion
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0;};

// Holt den ausgewählten Spieler aus der Liste
private _target = lbData[2902,lbCurSel (2902)];
_target = call compile format ["%1", _target];

// Überprüft, ob der ausgewählte Spieler gültig ist
if (isNil "_target" || {isNull _target}) exitWith {};
if (_target isEqualTo player) exitWith {
    hint localize "STR_ANOTF_Error";
};

// Überprüft, ob der ausgewählte Spieler sich in einem Fahrzeug befindet
if !(vehicle _target isEqualTo _target) exitWith {
    hint localize "STR_Admin_CannotTpHere";
};

// Teleportiert den ausgewählten Spieler zu Ihnen
_target setPos (getPos player);
hint format [localize "STR_NOTF_haveTPedToYou",_target getVariable ["realname",name _target]];
