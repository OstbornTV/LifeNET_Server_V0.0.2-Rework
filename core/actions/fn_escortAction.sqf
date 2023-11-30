#include "..\..\script_macros.hpp"
/*
    File: fn_escortAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Attaches the desired person (_unit) to the player (player) and "escorts them".
*/
params [
    ["_unit", objNull, [objNull]]
];

// Überprüfe, ob der Spieler bereits jemanden eskortiert
if (!isNull (player getVariable ["escortingPlayer",objNull])) exitWith {};
// Überprüfe, ob das zu eskortierende Objekt gültig ist
if (isNull _unit || {!isPlayer _unit}) exitWith {};
// Überprüfe, ob das zu eskortierende Objekt auf der richtigen Seite ist
if !(side _unit in [civilian, independent]) exitWith {};
// Überprüfe, ob der Spieler nahe genug am zu eskortierenden Objekt ist
if (player distance _unit > 3) exitWith {};

// Befestige das zu eskortierende Objekt am Spieler
_unit attachTo [player, [0.1, 1.1, 0]];
// Setze die entsprechenden Variablen für den Spieler und das zu eskortierende Objekt
player setVariable ["escortingPlayer", _unit];
player setVariable ["isEscorting", true];
_unit setVariable ["Escorting", true, true];

// Starte einen neuen Thread für das zu eskortierende Objekt
[_unit] spawn {
    params [
        ["_unit", objNull, [objNull]]
    ];
    // Warte, bis das zu eskortierende Objekt nicht mehr eskortiert wird
    waitUntil {!(_unit getVariable ["Escorting", false])};

    // Setze die Eskortierungsvariablen zurück, wenn das zu eskortierende Objekt nicht mehr eskortiert wird
    player setVariable ["escortingPlayer", nil];
    player setVariable ["isEscorting", false];
};
