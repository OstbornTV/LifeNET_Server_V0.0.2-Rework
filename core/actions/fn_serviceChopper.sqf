#include "..\..\script_macros.hpp"
/*
    File: fn_serviceChopper.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Main functionality for the chopper service paid, to be replaced in later version.
*/

// Deaktiviere die Serialisierung, um mögliche Probleme zu vermeiden
disableSerialization;

// Überprüfe, ob eine Aktion bereits in Benutzung ist
if (life_action_inUse) exitWith {hint localize "STR_NOTF_Action"};

// Holen Sie sich die Kosten für den Hubschrauberservice aus den Spieleinstellungen
private _serviceCost = LIFE_SETTINGS(getNumber, "service_chopper");

// Suche nach Hubschraubern in der Nähe des Servicepunkts
private _search = nearestObjects [getPos air_sp, ["Air"], 10];

// Wenn keine Hubschrauber gefunden werden, gib einen Hinweis aus und beende den Code
if (_search isEqualTo []) exitWith {
    hint localize "STR_Service_Chopper_NoAir";
};

// Überprüfe, ob der Spieler genug Bargeld hat
if (CASH < _serviceCost) exitWith {
    hint format [localize "STR_Service_Chopper_NotEnough", _serviceCost];
};

// Markiere die Aktion als in Benutzung
life_action_inUse = true;

// Setup für den Fortschrittsbalken
"progressBar" cutRsc ["life_progress", "PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format [localize "STR_Service_Chopper_Servicing", "waiting..."];
_progress progressSetPosition 0.01;
private _cP = 0.01;

// Fortschrittsbalkenanimation
for "_i" from 0 to 1 step 0 do {
    uiSleep 0.2;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format [localize "STR_Service_Chopper_Servicing", round(_cP * 100)];
    if (_cP >= 1) exitWith {};
};

// Holen Sie sich den nächstgelegenen Hubschrauber aus der Suche
_search params ["_nearestChopper"];

// Überprüfen Sie, ob der Hubschrauber lebendig ist und sich in der Nähe des Servicepunkts befindet
if (!alive _nearestChopper || {_nearestChopper distance air_sp > 15}) exitWith {
    // Setze die Aktion als nicht mehr in Benutzung und gib einen Hinweis aus
    life_action_inUse = false;
    hint localize "STR_Service_Chopper_Missing";
};

// Ziehe die Servicekosten vom Bargeld des Spielers ab
CASH = CASH - _serviceCost;

// Setze den Kraftstoff des Hubschraubers auf 1 und repariere ihn
if (!local _nearestChopper) then {
    [_nearestChopper, 1] remoteExecCall ["life_fnc_setFuel", _nearestChopper];
} else {
    _nearestChopper setFuel 1;
};

_nearestChopper setDamage 0;

// Beende die Fortschrittsanzeige und gib einen Hinweis aus
"progressBar" cutText ["", "PLAIN"];
titleText [localize "STR_Service_Chopper_Done", "PLAIN"];
life_action_inUse = false;
