#include "..\..\script_macros.hpp"
/*
    File: fn_gangLeave.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Verlässt die Gang 32 Stunden später...
*/
// Deklariere lokale Variablen "_unitID" und "_members"
private ["_unitID","_members"];

// Überprüfe, ob der Spieler der Anführer der Gang ist, und brich ab, wenn dies der Fall ist
if (getPlayerUID player isEqualTo (group player getVariable "gang_owner")) exitWith {hint localize "STR_GNOTF_LeaderLeave"};

// Erhalte die eindeutige Spieler-ID des Spielers
_unitID = getPlayerUID player;
// Erhalte die aktuelle Liste der Gangmitglieder
_members = group player getVariable "gang_members";
// Überprüfe, ob die Liste existiert und vom richtigen Typ ist
if (isNil "_members") exitWith {};
if (!(_members isEqualType [])) exitWith {};

// Entferne die Spieler-ID des Spielers aus der Liste der Gangmitglieder
_members = _members - [_unitID];
// Aktualisiere die Liste der Gangmitglieder in der Spielergruppe
group player setVariable ["gang_members",_members,true];

// Rufe die Funktion "life_fnc_clientGangLeft" auf, um den Spieler aus der Gang zu entfernen
call life_fnc_clientGangLeft;

// Überprüfe, ob der Headless Client aktiv ist
if (life_HC_isActive) then {
    // Aktualisiere die Datenbank über den Headless Client
    [4,group player] remoteExec ["HC_fnc_updateGang",HC_Life];
} else {
    // Aktualisiere die Datenbank über den Reservierungsserver
    [4,group player] remoteExec ["TON_fnc_updateGang",RSERV];
}

// Schließe das aktuelle Dialogfenster
closeDialog 0;