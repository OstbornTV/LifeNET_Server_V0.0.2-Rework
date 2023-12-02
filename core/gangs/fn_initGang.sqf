#include "..\..\script_macros.hpp"
/*
    File: fn_initGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Hauptinitialisierung für Gangs.
*/
// Deklariere lokale Variablen
private ["_exitLoop","_group","_wait"];
// Überprüfe, ob der Spieler nicht auf der Seite der Zivilisten ist
if !(playerSide isEqualTo civilian) exitWith {}; // Was zum Teufel?
// Füge den Spieler der Zivilistengruppe hinzu
[player] join (createGroup civilian);
// Überprüfe, ob es Gangdaten gibt
if (count life_gangData isEqualTo 0) exitWith {}; // Was zum Teufel?

// Zufällige Verzögerung vor dem Fortfahren
_wait = round(random(8));
sleep _wait;

// Durchlaufe, um sicherzustellen, dass keine Gruppe bereits mit der Gang erstellt wurde
_exitLoop = false;
{
    _groupName = _x getVariable "gang_name";
    // Überprüfe, ob der Gruppenname vorhanden ist
    if (!isNil "_groupName") then {
        _groupOwner = _x getVariable ["gang_owner",""];
        _groupID = _x getVariable "gang_id";
        // Überprüfe, ob der Gruppeninhaber und die Gruppen-ID vorhanden sind
        if (_groupOwner isEqualTo "" || isNil "_groupID") exitWith {}; // Ernsthaft?
        // Überprüfe, ob die Gangdaten übereinstimmen
        if ((life_gangData select 0) isEqualTo _groupID && {(life_gangData select 1) isEqualTo _groupOwner}) exitWith {_group = _x; _exitLoop = true;};
    };
} forEach allGroups;

// Überprüfe, ob eine Gruppe gefunden wurde
if (!isNil "_group") then {
    // Füge den Spieler der vorhandenen Gruppe hinzu
    [player] join _group;
    // Überprüfe, ob der Spieler der Eigentümer der Gang ist
    if ((life_gangData select 1) isEqualTo getPlayerUID player) then {
        // Führe die Funktion für den Gangführer aus
        [_unit, _group] remoteExecCall ["life_fnc_clientGangLeader", _group, _group];
    };
} else {
    // Erstelle eine neue Gruppe für die Gang
    _group = group player;
    // Setze die Gruppenvariablen basierend auf den Gangdaten
    _group deleteGroupWhenEmpty true;
    _group setVariable ["gang_id",(life_gangData select 0),true];
    _group setVariable ["gang_owner",(life_gangData select 1),true];
    _group setVariable ["gang_name",(life_gangData select 2),true];
    _group setVariable ["gang_maxMembers",(life_gangData select 3),true];
    _group setVariable ["gang_bank",(life_gangData select 4),true];
    _group setVariable ["gang_members",(life_gangData select 5),true];
};