#include "..\..\script_macros.hpp"
/*
    File: fn_bankDeposit.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Behandelt die Funktionalität der Geldeinzahlung auf das Bankkonto in Altis Life.
*/

// Lokale Variable für den Betrag deklarieren
private ["_value"];

// Extrahiere den Betrag aus dem Steuerelement
_value = parseNumber(ctrlText 2702);

// Überprüfe verschiedene Bedingungen, um sicherzustellen, dass die Einzahlung gültig ist
if (_value > 999999 || _value < 0 || !([str(_value)] call life_util_fnc_isNumber) || _value > CASH) exitWith {
    // Zeige eine Fehlermeldung entsprechend der fehlgeschlagenen Überprüfungen
    hint localize [
        "STR_ATM_GreaterThan", "STR_ATM_notnumeric", "STR_ATM_NotEnoughCash"
    ] select [
        (_value > 999999), (_value < 0), !([str(_value)] call life_util_fnc_isNumber), (_value > CASH)
    ];
};

// Führe die Einzahlung durch und aktualisiere die Kontostände
CASH = CASH - _value;
BANK = BANK + _value;

// Zeige eine Erfolgsmeldung
hint format [localize "STR_ATM_DepositSuccess", [_value] call life_fnc_numberText];

// Aktualisiere das ATM-Menü und sende partielle Updates an die Clients
[] call life_fnc_atmMenu;
[6] call SOCK_fnc_updatePartial;

// Protokolliere die Einzahlung, wenn aktiviert
if (LIFE_SETTINGS(getNumber, "player_moneyLog") isEqualTo 1) then {
    money_log = format [
        localize ["STR_DL_ML_depositedBank", "STR_DL_ML_depositedBank_BEF"],
        profileName, (getPlayerUID player), _value, [BANK, CASH] call life_fnc_numberText
    ];
    publicVariableServer "money_log";
};
