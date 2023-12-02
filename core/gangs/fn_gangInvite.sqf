#include "..\..\script_macros.hpp"
/*
    File: fn_gangInvite.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Bittet den Spieler um eine Einladung.
*/
// Parameterdefinition
private ["_action","_grpMembers"];
params [
    ["_name","",[""]],
    ["_group",grpNull,[grpNull]]
];

// Überprüfe, ob der Name leer ist oder die Gruppe nicht vorhanden ist
if (_name isEqualTo "" || isNull _group) exitWith {}; // Beende den Code, wenn der Name leer ist oder die Gruppe nicht vorhanden ist (Fehlermeldung)

// Überprüfe, ob der Spieler bereits in einer Gang ist
if (!isNil {(group player) getVariable "gang_name"}) exitWith {hint localize "STR_GNOTF_AlreadyInGang";};

// Hole den Gangnamen
_gangName = _group getVariable "gang_name";

// Zeige eine Einladungsnachricht und zwei Schaltflächen (Ja/Nein)
_action = [
    format [localize "STR_GNOTF_InviteMSG",_name,_gangName],
    localize "STR_Gang_Invitation",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Überprüfe, welche Aktion der Spieler gewählt hat
if (_action) then {
    // Spieler hat die Einladung angenommen
    [player] join _group;

    // Aktualisiere die Ganginformationen (abhängig davon, ob der Server oder der Headless Client aktiv ist)
    if (life_HC_isActive) then {
        [4,_group] remoteExecCall ["HC_fnc_updateGang",HC_Life];
    } else {
        [4,_group] remoteExecCall ["TON_fnc_updateGang",RSERV];
    };

} else {
    // Spieler hat die Einladung abgelehnt
    // Entferne die Spieler-UID aus der Liste der Gangmitglieder
    _grpMembers = _group getVariable "gang_members";
    _grpMembers = _grpMembers - [getPlayerUID player];
    _group setVariable ["gang_members",_grpMembers,true];

    // Aktualisiere die Ganginformationen (abhängig davon, ob der Server oder der Headless Client aktiv ist)
    if (life_HC_isActive) then {
        [4,_group] remoteExecCall ["HC_fnc_updateGang",HC_Life];
    } else {
        [4,_group] remoteExecCall ["TON_fnc_updateGang",RSERV];
    };
};
