#include "..\..\script_macros.hpp"
/*
    File: fn_clientGangLeader.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Ernennt den Spieler zum Anführer der Gang
*/

// Parameterdefinition
params [
    ["_unit", objNull, [objNull]], // Der Spieler, der zum Anführer ernannt wird
    ["_group", grpNull, [grpNull]] // Die Ganggruppe
];

// Setze den Rang des Spielers auf "COLONEL"
_unit setRank "COLONEL";

// Beende die Funktion, wenn die lokale Ganggruppe nicht vorhanden ist
if !(local _group) exitWith {};

// Setze den Spieler als Anführer der Ganggruppe
_group selectLeader _unit;

// Beende die Funktion, wenn der Spieler nicht gleich dem lokalen Spieler ist
if !(_unit isEqualTo player) exitWith {};

// Zeige einen Hinweis, dass der Spieler zum Anführer ernannt wurde
hint localize "STR_GNOTF_GaveTransfer";