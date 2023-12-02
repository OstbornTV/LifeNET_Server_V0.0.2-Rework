#include "..\..\script_macros.hpp"
/*
    File: fn_gangInvitePlayer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Lädt den Spieler in die Gang ein.
*/
// Deklariere lokale Variable "_unit"
private "_unit";
// Deaktiviere die Serialisierung
disableSerialization;

// Überprüfe, ob ein Spieler ausgewählt wurde
if ((lbCurSel 2632) isEqualTo -1) exitWith {hint localize "STR_GNOTF_SelectPerson"};
// Rufe die Funktion CONTROL_DATA auf, um den ausgewählten Spieler zu erhalten
_unit = call compile format ["%1",CONTROL_DATA(2632)];

// Überprüfe, ob der Spieler ungültig ist
if (isNull _unit) exitWith {}; // Spieler ist ungültig
if (_unit == player) exitWith {hint localize "STR_GNOTF_InviteSelf"}; // Spieler kann sich nicht selbst einladen
// Überprüfe, ob der Spieler bereits in einer Gang ist
if (!isNil {(group _unit) getVariable "gang_name"}) exitWith {hint localize "STR_GNOTF_playerAlreadyInGang";};

// Überprüfe, ob die maximale Anzahl von Gangmitgliedern erreicht wurde
if (count(group player getVariable ["gang_members",8]) == (group player getVariable ["gang_maxMembers",8])) exitWith {hint localize "STR_GNOTF_MaxSlot"};

// Zeige eine Einladungsnachricht und zwei Schaltflächen (Ja/Nein) an
_action = [
    format [localize "STR_GNOTF_InvitePlayerMSG",_unit getVariable ["realname",name _unit]],
    localize "STR_Gang_Invitation",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Überprüfe, welche Aktion der Spieler gewählt hat
if (_action) then {
    // Spieler hat die Einladung angenommen
    // Rufe die Funktion "life_fnc_gangInvite" mit den entsprechenden Parametern auf
    [profileName,group player] remoteExec ["life_fnc_gangInvite",_unit];
    // Aktualisiere die Liste der Gangmitglieder
    _members = group player getVariable "gang_members";
    _members pushBack getPlayerUID _unit;
    group player setVariable ["gang_members",_members,true];
    // Zeige eine Benachrichtigung über die gesendete Einladung an
    hint format [localize "STR_GNOTF_InviteSent",_unit getVariable ["realname",name _unit]];
} else {
    // Spieler hat die Einladung abgelehnt
    hint localize "STR_GNOTF_InviteCancel";
};