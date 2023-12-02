#include "..\..\script_macros.hpp"
/*
    File: fn_gangNewLeader.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Etwas über ein Aufhören.
*/
// Deklariere lokale Variablen
private ["_unit","_unitID","_members","_action","_index"];
// Deaktiviere die Serialisierung
disableSerialization;

// Überprüfe, ob ein Spieler ausgewählt ist
if ((lbCurSel 2621) isEqualTo -1) exitWith {hint localize "STR_GNOTF_TransferSelect"};
// Erhalte den ausgewählten Spieler aus dem Steuerelement
_unit = call compile format ["%1",CONTROL_DATA(2621)];

// Breche ab, wenn die ausgewählte Einheit ungültig ist
if (isNull _unit) exitWith {}; // Schlechte Einheit?
// Breche ab, wenn der ausgewählte Spieler der aktuelle Spieler ist
if (_unit == player) exitWith {hint localize "STR_GNOTF_TransferSelf"};

// Zeige eine Bestätigungsnachricht an
_action = [
    format [localize "STR_GNOTF_TransferMSG",_unit getVariable ["realname",name _unit]],
    localize "STR_Gang_Transfer",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Führe die Aktion durch, wenn der Spieler zustimmt
if (_action) then {
    // Erhalte die eindeutige Spieler-ID des ausgewählten Spielers
    _unitID = getPlayerUID _unit;
    // Breche ab, wenn die Spieler-ID leer ist (unwahrscheinlich)
    if (_unitID isEqualTo "") exitWith {hint localize "STR_GNOTF_badUID";};
    // Erhalte die Gruppe des aktuellen Spielers
    private _group = group player;
    // Setze den neuen Anführer in den Gruppenvariablen
    _group setVariable ["gang_owner",_unitID,true];
    // Rufe die Funktion zum Aktualisieren des Anführers auf dem Client und im Server auf
    [_unit, _group] remoteExecCall ["life_fnc_clientGangLeader", _group, _group];

    // Aktualisiere die Gangdatenbank
    if (life_HC_isActive) then {
        [3,group player] remoteExec ["HC_fnc_updateGang",HC_Life];
    } else {
        [3,group player] remoteExec ["TON_fnc_updateGang",RSERV];
    };
} else {
    // Zeige eine Meldung an, dass der Vorgang abgebrochen wurde
    hint localize "STR_GNOTF_TransferCancel";
};
// Aktualisiere das Gangmenü nach der Aktion
[] call life_fnc_gangMenu;
