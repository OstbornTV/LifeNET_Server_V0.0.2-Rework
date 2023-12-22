#include "..\..\script_macros.hpp"
/*
    File: fn_wireTransfer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initiates the wire-transfer
*/
params [
    ["_value", 0, [0]],
    ["_from", "", [""]]
];

// Überprüfe, ob der übergebene Wert und der Absender gültig sind
if (_value isEqualTo 0 || _from isEqualTo "" || _from isEqualTo profileName) exitWith {};

// Führe die Überweisung durch und aktualisiere die Kontostände
BANK = BANK + _value;

// Sende partielle Updates an die Clients
[1] call SOCK_fnc_updatePartial;

// Zeige eine Erfolgsmeldung
hint format [localize "STR_ATM_WireTransfer", _from, [_value] call life_fnc_numberText];
