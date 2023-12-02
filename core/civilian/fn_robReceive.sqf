#include "..\..\script_macros.hpp"
/*
    File: fn_robReceive.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Verarbeitet die Annahme von geraubtem Geld.
*/
params [
    ["_cash", 0, [0]],
    ["_victim", objNull, [objNull]]
];

// Überprüfen, ob der beraubte Spieler der aktuelle Spieler ist
if (player isEqualTo _victim) exitWith {};

// Überprüfen, ob kein Geld übergeben wurde
if (_cash isEqualTo 0) exitWith {
    titleText [localize "STR_Civ_RobFail", "PLAIN"];
};

// Das Geld dem aktuellen Spieler hinzufügen
CASH = CASH + _cash;

// Spielerdaten aktualisieren
[0] call SOCK_fnc_updatePartial;

// Erfolgreiche Benachrichtigung anzeigen
titleText [format [localize "STR_Civ_Robbed", [_cash] call life_fnc_numberText], "PLAIN"];

// Geldtransaktion protokollieren
if (LIFE_SETTINGS(getNumber, "player_moneyLog") isEqualTo 1) then {
    // Überprüfen, ob battlEye-freundliches Protokollieren aktiviert ist
    if (LIFE_SETTINGS(getNumber, "battlEye_friendlyLogging") isEqualTo 1) then {
        money_log = format [localize "STR_DL_ML_Robbed_BEF", [_cash] call life_fnc_numberText, _victim, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
    } else {
        money_log = format [localize "STR_DL_ML_Robbed", profileName, (getPlayerUID player), [_cash] call life_fnc_numberText, _victim, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
    };
    
    // Geldtransaktionsprotokoll an den Server senden
    publicVariableServer "money_log";
};
