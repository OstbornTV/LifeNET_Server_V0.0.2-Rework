#include "..\..\script_macros.hpp"
/*
    File: fn_gangKick.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Kickt einen Spieler aus deiner Gang.
*/
// Deklariere lokale Variable "_unit" und deaktiviere die Serialisierung
private ["_unit","_unitID","_members"];
disableSerialization;

// Überprüfe, ob ein Spieler ausgewählt wurde
if ((lbCurSel 2621) isEqualTo -1) exitWith {hint localize "STR_GNOTF_SelectKick"};
// Rufe die Funktion CONTROL_DATA auf, um den ausgewählten Spieler zu erhalten
_unit = call compile format ["%1",CONTROL_DATA(2621)];

// Überprüfe, ob der Spieler ungültig ist
if (isNull _unit) exitWith {}; // Spieler ist ungültig
// Überprüfe, ob versucht wird, sich selbst aus der Gang zu kicken
if (_unit == player) exitWith {hint localize "STR_GNOTF_KickSelf"};

// Erhalte die eindeutige Spieler-ID des ausgewählten Spielers
_unitID = getPlayerUID _unit;
// Erhalte die aktuelle Liste der Gangmitglieder
_members = group player getVariable "gang_members";
// Überprüfe, ob die Liste existiert und vom richtigen Typ ist
if (isNil "_members") exitWith {};
if (!(_members isEqualType [])) exitWith {};

// Entferne die Spieler-ID des ausgewählten Spielers aus der Liste der Gangmitglieder
_members = _members - [_unitID];
// Aktualisiere die Liste der Gangmitglieder in der Spielergruppe
group player setVariable ["gang_members",_members,true];

// Rufe die Funktion "life_fnc_clientGangKick" für den ausgewählten Spieler auf
remoteExecCall ["life_fnc_clientGangKick",_unit];

// Überprüfe, ob der Headless Client aktiv ist
if (life_HC_isActive) then {
    // Aktualisiere die Datenbank über den Headless Client
    [4,group player] remoteExec ["HC_fnc_updateGang",HC_Life];
} else {
    // Aktualisiere die Datenbank über den Reservierungsserver
    [4,group player] remoteExec ["TON_fnc_updateGang",RSERV];
}

// Rufe die Funktion "life_fnc_gangMenu" auf, um das Gangmenü zu aktualisieren
[] call life_fnc_gangMenu;