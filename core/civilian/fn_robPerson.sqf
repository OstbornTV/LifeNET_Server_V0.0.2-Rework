#include "..\..\script_macros.hpp"
/*
    File: fn_robPerson.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Beraubt eine Person.
*/
params [
    ["_robber", objNull, [objNull]]
];

if (isNull _robber) exitWith {};

// Überprüfen, ob die Person Geld hat
if (CASH > 0) then {
    // Geld an den Räuber senden
    [CASH, player] remoteExecCall ["life_fnc_robReceive", _robber];

    // Fahndungslevel erhöhen
    if (life_HC_isActive) then {
        [getPlayerUID _robber, _robber getVariable ["realname", name _robber], "211"] remoteExecCall ["HC_fnc_wantedAdd", HC_Life];
    } else {
        [getPlayerUID _robber, _robber getVariable ["realname", name _robber], "211"] remoteExecCall ["life_fnc_wantedAdd", RSERV];
    };

    // Benachrichtigung senden
    [1, "STR_NOTF_Robbed", true, [_robber getVariable ["realname", name _robber], profileName, [CASH] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

    // Das eigene Geld auf 0 setzen
    CASH = 0;

    // Spielerdaten aktualisieren
    [0] call SOCK_fnc_updatePartial;
} else {
    // Benachrichtigung senden, dass das Berauben fehlgeschlagen ist
    [2, "STR_NOTF_RobFail", true, [profileName]] remoteExecCall ["life_fnc_broadcast", _robber];
};
