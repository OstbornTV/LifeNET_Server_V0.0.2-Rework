#include "\life_hc\hc_macros.hpp"
/*
    File: fn_removeGang.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Disbands a gang and removes it from the database.
*/
params [
    ["_group", grpNull, [grpNull]]
];

// Überprüfen, ob die Gruppe vorhanden ist
if (isNull _group) exitWith {"Error: Invalid group."};

// Gruppen-ID aus den Gruppenvariablen abrufen
private _groupID = _group getVariable ["gang_id", -1];

// Überprüfen, ob die Gruppen-ID gültig ist
if (_groupID isEqualTo -1) exitWith {"Error: Invalid gang ID."};

// Gang-Besitzer entfernen und Gang aus der Datenbank löschen (HeadlessClient)
_group setVariable ["gang_owner", nil, true];
[format ["deleteGang:%1", _groupID], 1] call HC_fnc_asyncCall;

// Gang auf dem Server disbanden und Benachrichtigung an die Mitglieder senden
[_group] remoteExecCall ["life_fnc_gangDisbanded", (units _group)];

// Kurze Verzögerung, um sicherzustellen, dass die Benachrichtigung gesendet wird
uiSleep 5;

// Gruppe auf dem Server löschen
deleteGroup _group;
