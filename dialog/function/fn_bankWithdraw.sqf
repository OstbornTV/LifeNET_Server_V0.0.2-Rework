#include "..\..\script_macros.hpp"
/*
    File: fn_bankWithdraw.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Behandelt die Funktionalität des Geldabhebens vom Bankkonto des Spielers in Altis Life.
*/

// Lokale Variable für den Abhebungsbetrag deklarieren
private ["_value"];

// Extrahiere den Betrag aus dem Steuerelement
_value = parseNumber(ctrlText 2702);

// Überprüfe verschiedene Bedingungen, um sicherzustellen, dass die Abhebung gültig ist
if (_value > 999999 || _value < 0 || !([str(_value)] call life_util_fnc_isNumber) || (_value > BANK) || (_value < 100 && BANK > 20000000)) exitWith {
    // Zeige eine Fehlermeldung entsprechend der fehlgeschlagenen Überprüfungen
    hint localize [
        "STR_ATM_WithdrawMax", "STR_ATM_notnumeric", "STR_ATM_NotEnoughFunds", "STR_ATM_WithdrawMin"
    ] select [
        (_value > 999999), (_value < 0), !([str(_value)] call life_util_fnc_isNumber), (_value > BANK), (_value < 100 && BANK > 20000000)
    ];

    // Beende das Skript
    exitWith {};
};

// Führe die Abhebung durch und aktualisiere die Kontostände
CASH = CASH + _value;
BANK = BANK - _value;

// Zeige eine Erfolgsmeldung
hint format [localize "STR_ATM_WithdrawSuccess", [_value] call life_fnc_numberText];

// Aktualisiere das ATM-Menü und sende partielle Updates an die Clients
[] call life_fnc_atmMenu;
[6] call SOCK_fnc_updatePartial;

// Protokolliere die Abhebung, wenn aktiviert
if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
    money_log = format [
        localize ["STR_DL_ML_withdrewBank", "STR_DL_ML_withdrewBank_BEF"],
        profileName, (getPlayerUID player), _value, [BANK, CASH] call life_fnc_numberText
    ];
    publicVariableServer "money_log";
};
