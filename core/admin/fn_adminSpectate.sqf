#include "..\..\script_macros.hpp"
/*
    File: fn_adminSpectate.sqf
    Author: ColinM9991
    
    Description:
    Spectates the chosen player.
*/

// Überprüft das Admin-Level für die Ausführung dieser Aktion
if (FETCH_CONST(life_adminlevel) < 3) exitWith {
    closeDialog 0;
};

// Holt den ausgewählten Spieler aus der Liste
private _unit = lbData[2902, lbCurSel (2902)];
_unit = call compile format ["%1", _unit];

// Beendet die Ausführung, wenn keine gültigen Spielerinformationen vorliegen
if (isNil "_unit" || {isNull _unit}) exitWith {};

// Beendet die Ausführung, wenn der ausgewählte Spieler der aktuelle Spieler ist
if (_unit isEqualTo player) exitWith {
    hint localize "STR_ANOTF_Error";
};

// Schließt das Dialogfenster
closeDialog 0;

// Wechselt zur internen Kameraansicht des ausgewählten Spielers
_unit switchCamera "INTERNAL";

// Zeigt eine Meldung an, dass das Spectating gestartet wurde
hint format [localize "STR_NOTF_nowSpectating", _unit getVariable ["realname", name _unit]];

// Fügt einen KeyDown-EventHandler hinzu, um das Spectating zu beenden
AM_Exit = (findDisplay 46) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 68) then {(findDisplay 46) displayRemoveEventHandler ['KeyDown', AM_Exit]; player switchCamera 'INTERNAL'; hint localize 'STR_NOTF_stoppedSpectating';}; false"];
