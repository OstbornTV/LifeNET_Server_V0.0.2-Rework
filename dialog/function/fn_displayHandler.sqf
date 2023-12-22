#include "..\..\script_macros.hpp"
/*
    File: fn_displayHandler.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Behandelt Master-Display-Ereignisse.
*/

// Lokale Variablen deklarieren
private ["_control", "_code", "_shift", "_ctrlKey", "_alt", "_handled"];

// Standardmäßig wird davon ausgegangen, dass das Event nicht bearbeitet wurde
_handled = false;

// Esc-Taste Handler
if ((_this select 1) isEqualTo 1) then {
    // Wenn die Esc-Taste gedrückt wurde, markiere das Event als bearbeitet
    _handled = true;
};

// Gibt an, ob das Event bearbeitet wurde oder nicht
_handled;
