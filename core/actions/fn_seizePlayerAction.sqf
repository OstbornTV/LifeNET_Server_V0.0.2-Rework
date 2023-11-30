#include "..\..\script_macros.hpp"
/*
    File: fn_seizePlayerAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Starts the seize process..
    Based off Tonic's fn_searchAction.sqf
*/

// Der Spieler, der durchsucht wird
params [
    ["_unit", objNull, [objNull]]
];

// Überprüfen, ob der Spieler gültig ist
if (isNull _unit) exitWith {};

// Kurze Pause für die Benutzeroberfläche
sleep 2;

// Überprüfen Sie die Bedingungen für die Beschlagnahme
if (player distance _unit > 5 || !alive player || !alive _unit) exitWith {
    hint localize "STR_NOTF_CannotSeizePerson";
};

// Den Server anweisen, die Beschlagnahme durchzuführen
[player] remoteExec ["life_fnc_seizeClient", _unit];

// Die Aktion als nicht mehr in Benutzung markieren
life_action_inUse = false;
