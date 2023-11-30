#include "..\..\script_macros.hpp"
/*
    File: fn_adminID.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Gibt empfangene Informationen im Admin-Menü aus.
*/

// Deaktiviert die Serialisierung
disableSerialization;

// Parameterdefinition
params [
    ["_ret", -1, [0]]
];

// Sucht das Display und den Textkontrolle
private _display = findDisplay 2900;
private _text = _display displayCtrl 2903;

// Setzt den strukturierten Text der Textkontrolle
_text ctrlSetStructuredText parseText format ["ID: %1",_ret];
