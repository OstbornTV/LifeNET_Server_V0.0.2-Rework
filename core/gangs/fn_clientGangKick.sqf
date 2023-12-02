#include "..\..\script_macros.hpp"
/*
    File: fn_clientGangKick.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Behandelt das Herauswerfen aus einer Gang
*/

// Setze die Gang-Zugehörigkeit des Spielers auf null
life_my_gang = grpNull;

// Füge den Spieler der Zivilistengruppe hinzu
[player] joinSilent (createGroup civilian);

// Zeige einen Hinweis, dass der Spieler aus der Gang geworfen wurde
hint localize "STR_GNOTF_KickOutGang";