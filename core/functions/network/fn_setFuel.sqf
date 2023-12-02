#include "..\..\script_macros.hpp"
/*
    File: fn_setFuel.sqf
    Author: Bryan "Tonic" Boardwine

    Description: Used to set fuel levels in vehicles. (Ex. Service Chopper)
*/

params [
    ["_object", objNull, [objNull]], // Das Fahrzeugobjekt, dessen Kraftstofflevel gesetzt wird
    ["_value", 1, [0]] // Der Kraftstoffwert, der gesetzt werden soll
];

// Exit, wenn das Fahrzeugobjekt nicht vorhanden ist
if (isNull _object) exitWith {};

// Setze das Kraftstofflevel des Fahrzeugs auf den angegebenen Wert
_object setFuel _value;
