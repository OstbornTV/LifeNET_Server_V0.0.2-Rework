#include "..\..\script_macros.hpp"
/*
    File: fn_surrender.sqf
    Author:

    Description: Causes player to put their hands on their head.
*/

// Überprüfen, ob der Spieler gefesselt ist oder eskortiert wird
if (player getVariable ["restrained", false]) exitWith {};
if (player getVariable ["Escorting", false]) exitWith {};

// Überprüfen, ob der Spieler in einem Fahrzeug ist
if (!isNull objectParent player) exitWith {};

// Überprüfen, ob die Geschwindigkeit des Spielers größer als 1 ist
if (speed player > 1) exitWith {};

// Aktuellen Zustand des Spieler-Surrender überprüfen
private _currentState = player getVariable ["playerSurrender", false];

// Den Spieler in den Surrender-Zustand versetzen oder daraus entfernen
player setVariable ["playerSurrender", !_currentState, true];

// Schleife, während der Spieler im Surrender-Zustand ist
while {player getVariable ["playerSurrender", false]} do {
    // Animation für Surrender abspielen
    player playMove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";

    // Überprüfen, ob der Spieler nicht mehr lebt oder in einem Fahrzeug ist
    if (!alive player || {!isNull objectParent player}) then {
        player setVariable ["playerSurrender", false, true];
    };
};

// Standard-Animation wiederherstellen, wenn der Surrender-Zustand aufgehoben wird
player playMoveNow "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnon";
