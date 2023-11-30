#include "..\..\script_macros.hpp"
/*
    File: fn_stopEscorting.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Detaches player(_unit) from the Escorter(player) and sets them back down.
*/

// Holen Sie sich die Einheit, die vom Spieler eskortiert wird
private _unit = player getVariable ["escortingPlayer", objNull];

// Notfallrückfall, wenn keine Einheit gefunden wird
if (isNull _unit) then {_unit = cursorTarget;};

// Beende den Code, wenn keine Einheit gefunden wird
if (isNull _unit) exitWith {};

// Beende den Code, wenn die Einheit nicht eskortiert wird
if (!(_unit getVariable ["Escorting", false])) exitWith {};

// Trenne die Einheit von ihrem Escorter
detach _unit;

// Setze die "Escorting"-Variable der Einheit auf false
_unit setVariable ["Escorting", false, true];

// Setze die "isEscorting"-Variable des Spielers auf false
player setVariable ["isEscorting", false];
