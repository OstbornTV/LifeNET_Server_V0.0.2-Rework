#include "..\..\script_macros.hpp"
/*
    File: fn_adminDebugCon.sqf
    Author: ColinM9991

    Description:
    Öffnet die Debug-Konsole.
*/

// Überprüfen Sie den Admin-Level
if (FETCH_CONST(life_adminlevel) < 5) exitWith {
    closeDialog 0;
    hint localize "STR_NOTF_adminDebugCon";
};

// Setzen Sie die Debug-Variable auf true und öffnen Sie das Debug-Konsolenfenster
life_admin_debug = true;
createDialog "RscDisplayDebugPublic";

// Broadcast-Nachricht darüber, dass der Admin die Debug-Konsole geöffnet hat
[0, format [localize "STR_NOTF_adminHasOpenedDebug", profileName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
