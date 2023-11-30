#include "..\..\script_macros.hpp"
/*
    File: fn_searchAction.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Starts the searching process.
*/
params [
    ["_unit", objNull, [objNull]]
];

// Überprüfen, ob das Zielobjekt vorhanden ist
if (isNull _unit) exitWith {};

// Informieren Sie den Spieler darüber, dass die Suche begonnen hat
hint localize "STR_NOTF_Searching";

// Kurze Pause für die Benutzeroberfläche
sleep 2;

// Überprüfen Sie die Bedingungen für die Suche
if (player distance _unit > 5 || {!alive player} || {!alive _unit}) exitWith {
    hint localize "STR_NOTF_CannotSearchPerson";
};

// Rufen Sie die searchClient-Funktion auf dem Server auf und übergeben Sie das Zielobjekt
[player] remoteExec ["life_fnc_searchClient", _unit];

// Markieren Sie die Aktion als in Benutzung
life_action_inUse = true;
