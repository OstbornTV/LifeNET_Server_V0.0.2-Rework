#include "..\..\script_macros.hpp"
/*
    File: fn_adminFreeze.sqf
    Author: ColinM9991
    
    Description: Einfrieren des ausgewählten Spielers
*/
// Überprüfen Sie den Admin-Level
if (FETCH_CONST(life_adminlevel) < 4) exitWith {
    closeDialog 0;
    hint localize "STR_ANOTF_ErrorLevel";
};

// Holen Sie sich die ausgewählte Einheit aus dem Dropdown-Menü
private _unit = lbData[2902, lbCurSel (2902)];
_unit = call compile format ["%1", _unit];

// Überprüfen Sie, ob die Einheit gültig ist
if (isNil "_unit" || {isNull _unit}) exitWith {};
if (_unit isEqualTo player) exitWith {hint localize "STR_ANOTF_Error";};

// Rufen Sie die Funktion zum Einfrieren des Spielers auf
[player] remoteExecCall ["life_fnc_freezePlayer", _unit];
