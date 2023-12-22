#include "..\..\script_macros.hpp"
/*
    File: fn_gankBankResponse.sqf
    Author: DomT602
    Description:
    Empfängt die Antwort vom Server nach dem Versuch, die Bank auszurauben.
*/

// Parameter deklarieren und standardmäßigen Wert für "_value" setzen
params [
    ["_value", -1, [0]]
];

// Überprüfen, ob der Code von der richtigen Quelle kommt (Headless Client)
if (remoteExecutedOwner != ([2, HC_Life] select life_HC_isActive)) exitWith {};
// Überprüfen, ob der übergebene Wert gültig ist
if (_value isEqualTo -1) exitWith {};

// Erfolgsmeldung für den Geldraub anzeigen
hint format [localize "STR_ATM_WithdrawSuccessG", [_value] call life_fnc_numberText];
// Bargeld aktualisieren
CASH = CASH + _value;
// ATM-Menü aufrufen
[] call life_fnc_atmMenu;
