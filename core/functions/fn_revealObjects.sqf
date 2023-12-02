/*
    File: fn_revealObjects.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Offenbart automatisch die nächsten Objekte innerhalb von 15 Metern, um beim Aufsammeln
    verschiedener statischer Objekte auf dem Boden wie Geld, Wasser, etc. zu helfen.

    Kann auf Low-End-Systemen oder bei Verwendung von AMD CPUs belastend sein.
*/

// Verwende Konstanten, um magische Zahlen zu vermeiden
#define REVEAL_DISTANCE 15

// Finde die nächsten Objekte im angegebenen Radius um die Position des Spielers
private _objects = nearestObjects[visiblePositionASL player, ["Land_CargoBox_V1_F","Land_BottlePlastic_V1_F","Land_TacticalBacon_F","Land_Can_V3_F","Land_CanisterFuel_F","Land_Money_F","Land_Suitcase_F","CAManBase"], REVEAL_DISTANCE];

// Durchlaufe jedes gefundene Objekt
{
    // Offenbare das Objekt für den Spieler
    player reveal _x;
    // Offenbare das Objekt für die Gruppe des Spielers
    (group player) reveal _x;
} forEach _objects;
