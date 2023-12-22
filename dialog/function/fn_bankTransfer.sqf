#include "..\..\script_macros.hpp"
/*
    File: fn_bankTransfer.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Behandelt die Funktionalität des Geldüberweisens an einen anderen Spieler in Altis Life.
*/

// Lokale Variablen für den Betrag, das Zielobjekt und die Überweisungsgebühr deklarieren
private ["_value", "_unit", "_tax"];

// Extrahiere den Betrag aus dem Steuerelement
_value = parseNumber(ctrlText 2702);

// Extrahiere das ausgewählte Ziel aus dem Drop-Down-Menü
_unit = call compile format ["%1",(lbData[2703,(lbCurSel 2703)])];

// Überprüfe verschiedene Bedingungen, um sicherzustellen, dass die Überweisung gültig ist
if (isNull _unit || (lbCurSel 2703) isEqualTo -1 || isNil "_unit" || _value > 999999 || _value < 0 || !([str(_value)] call life_util_fnc_isNumber) || (_value > BANK) || ((_value + (_value * LIFE_SETTINGS(getNumber,"bank_transferTax"))) > BANK)) exitWith {
    // Zeige eine Fehlermeldung entsprechend der fehlgeschlagenen Überprüfungen
    hint localize [
        "STR_ATM_NoneSelected", "STR_ATM_DoesntExist", "STR_ATM_TransferMax", "STR_ATM_NotEnoughFunds", "STR_ATM_SentMoneyFail"
    ] select [
        (isNull _unit), ((lbCurSel 2703) isEqualTo -1), isNil "_unit", (_value > 999999), (_value < 0), !([str(_value)] call life_util_fnc_isNumber), (_value > BANK), ((_value + (_value * LIFE_SETTINGS(getNumber,"bank_transferTax"))) > BANK)
    ];

    // Beende das Skript
    exitWith {};
};

// Überweisungsgebühr berechnen
_tax = _value * LIFE_SETTINGS(getNumber, "bank_transferTax");

// Führe die Überweisung durch und aktualisiere die Kontostände
BANK = BANK - (_value + _tax);

// Rufe das Remote-Skript auf dem Zielobjekt auf
[_value, profileName] remoteExecCall ["life_fnc_wireTransfer", _unit];

// Aktualisiere das ATM-Menü und sende partielle Updates an die Clients
[] call life_fnc_atmMenu;
[1] call SOCK_fnc_updatePartial;

// Zeige eine Erfolgsmeldung
hint format [localize "STR_ATM_SentMoneySuccess", [_value] call life_fnc_numberText, _unit getVariable ["realname", name _unit], [_tax] call life_fnc_numberText];

// Protokolliere die Überweisung, wenn aktiviert
if (LIFE_SETTINGS(getNumber, "player_moneyLog") isEqualTo 1) then {
    money_log = format [
        localize ["STR_DL_ML_transferredBank", "STR_DL_ML_transferredBank_BEF"],
        profileName, (getPlayerUID player), _value, _unit getVariable ["realname", name _unit], [BANK, CASH] call life_fnc_numberText
    ];
    publicVariableServer "money_log";
};
