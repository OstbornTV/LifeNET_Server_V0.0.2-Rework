#include "..\..\script_macros.hpp"
/*
    File: fn_demoChargeTimer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Startet den "Demo"-Timer für die Polizei.
*/

disableSerialization;

// Erstellt das Timer-Element auf dem Bildschirm
"lifeTimer" cutRsc ["life_timer", "PLAIN"];
private _uiDisp = uiNamespace getVariable "life_timer";
private _timer = _uiDisp displayCtrl 38301;
private _time = LIFE_SETTINGS(getNumber, "fed_chargeTime") * 60; // Zeit in Sekunden

// Schleife, die den Timer herunterzählt
for "_i" from _time to 0 step -1 do {
    // Überprüft, ob das Timer-Element vorhanden ist
    if (isNull _uiDisp) then {
        "lifeTimer" cutRsc ["life_timer", "PLAIN"];
        _uiDisp = uiNamespace getVariable "life_timer";
        _timer = _uiDisp displayCtrl 38301;
    };

    // Überprüft, ob die "Demo"-Ladung platziert wurde
    if (!(fed_bank getVariable ["chargeplaced", false])) exitWith {};

    // Setzt den Text des Timers auf die verbleibende Zeit im Format MM:SS
    _timer ctrlSetText ([_i, "MM:SS"] call BIS_fnc_secondsToString);
    
    uiSleep 1; // Kurze Verzögerung für die Anzeige in Sekunden
};

// Entfernt das Timer-Element vom Bildschirm
"lifeTimer" cutText ["", "PLAIN"];
