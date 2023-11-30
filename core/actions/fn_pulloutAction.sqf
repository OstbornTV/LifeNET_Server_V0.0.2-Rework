#include "..\..\script_macros.hpp"
/*
    File: fn_pulloutAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Pulls civilians out of a car if it's stopped.
*/

// Holen Sie sich die Besatzung des Fahrzeugs
private _crew = crew cursorObject;

// Durchlaufen Sie jede Einheit in der Besatzung
{
    // Überprüfen Sie, ob die Seite der Einheit nicht WEST ist
    if !(side _x isEqualTo west) then {
        // Setzen Sie die Variablen "transporting" und "Escorting" auf false
        _x setVariable ["transporting", false, true];
        _x setVariable ["Escorting", false, true];
        
        // Führen Sie die Remote-Execution-Funktion "life_fnc_pulloutVeh" für die Einheit aus
        [_x] remoteExecCall ["life_fnc_pulloutVeh", _x];
    };
    true
} count _crew;
