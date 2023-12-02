#include "..\..\script_macros.hpp"
/*
    File: fn_gangMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    31 Stunden ohne Schlaf, vergiss die Beschreibung.
*/
// Deklariere lokale Variablen
private ["_ownerID","_gangBank","_gangMax","_gangName","_members","_allUnits","_ctrl"];
// Deaktiviere die Serialisierung
disableSerialization;

// Überprüfe, ob das Dialogfenster bereits existiert, andernfalls erstelle es
if (isNull (findDisplay 2620)) then {
    // Erstelle das Dialogfenster "Life_My_Gang_Diag" und breche ab, wenn dies nicht möglich ist
    if (!(createDialog "Life_My_Gang_Diag")) exitWith {};
}

// Erhalte die eindeutige Spieler-ID des Ganganführers
_ownerID = group player getVariable ["gang_owner",""];
// Breche ab, wenn die Anführer-ID leer ist
if (_ownerID isEqualTo "") exitWith {closeDialog 0;}; // Schlechter Juju

// Erhalte Informationen über die Gang (Name, Bankguthaben, maximale Mitgliederzahl)
_gangName = group player getVariable "gang_name";
_gangBank = GANG_FUNDS;
_gangMax = group player getVariable "gang_maxMembers";

// Deaktiviere Steuerelemente, wenn der Spieler nicht der Anführer ist
if !(_ownerID isEqualTo getPlayerUID player) then {
    (CONTROL(2620,2622)) ctrlEnable false; // Upgrade
    (CONTROL(2620,2624)) ctrlEnable false; // Kick
    (CONTROL(2620,2625)) ctrlEnable false; // Set New Leader
    (CONTROL(2620,2630)) ctrlEnable false; // Invite Player
    (CONTROL(2620,2631)) ctrlEnable false; // Disband Gang
}

// Setze den Gangnamen und das Bankguthaben in den entsprechenden Steuerelementen
(CONTROL(2620,2629)) ctrlSetText _gangName;
(CONTROL(2620,601)) ctrlSetText format [(localize "STR_GNOTF_Funds")+ " $%1",[_gangBank] call life_fnc_numberText];

// Iteriere über die Spieler in der Gruppe
_members = CONTROL(2620,2621);
lbClear _members;
{
    if ((getPlayerUID _x) == _ownerID) then {
        _members lbAdd format ["%1 " +(localize "STR_GNOTF_GangLeader"),(_x getVariable ["realname",name _x])];
        _members lbSetData [(lbSize _members)-1,str(_x)];
    } else {
        _members lbAdd format ["%1",(_x getVariable ["realname",name _x])];
        _members lbSetData [(lbSize _members)-1,str(_x)];
    };
} forEach (units group player);

// Erstelle Listen aller Gruppenmitglieder und aller spielbaren Einheiten
_grpMembers = units group player;
_allUnits = playableUnits;

// Lösche die Einheiten aus der Liste, die bereits in der Gruppe sind oder eine andere Gang haben
{
    if (_x in _grpMembers || !(side _x isEqualTo civilian) && isNil {(group _x) getVariable "gang_id"}) then {
        _allUnits deleteAt _forEachIndex;
    };
} forEach _allUnits;

// Aktualisiere die Liste der einladbaren Spieler in der GUI
_ctrl = CONTROL(2620,2632);
lbClear _ctrl; // Leere die Liste
{
    _ctrl lbAdd format ["%1",_x getVariable ["realname",name _x]];
    _ctrl lbSetData [(lbSize _ctrl)-1,str(_x)];
} forEach _allUnits;
