#include "..\..\script_macros.hpp"
/*
    File: fn_clientGangLeft.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Verlässt die Gruppe (Gang)
*/

// Setze die Variable für meine Gang auf null
life_my_gang = grpNull;

// Der Spieler tritt der zivilen Gruppe bei (verlässt die Gang)
[player] joinSilent (createGroup civilian);

// Zeige einen Hinweis, dass die Gang verlassen wurde
hint localize "STR_GNOTF_LeaveGang";
