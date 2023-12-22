#include "..\..\script_macros.hpp"
/*
    File: fn_gangWithdraw.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Withdraws money from the gang bank.
*/
// Verhindere, dass die Funktion zu oft aufgerufen wird (Action Delay)
if ((time - life_action_delay) < 0.5) exitWith { hint localize "STR_NOTF_ActionDelay"; };

params [
    ["_deposit", false, [false]]
];

// Extrahiere den Wert aus dem Steuerfeld
private _value = parseNumber(ctrlText 2702);
// Extrahiere den aktuellen Gang-Fonds
private _gFund = GANG_FUNDS;

// Eine Reihe von Überprüfungen
if (isNil {(group player) getVariable "gang_name"}) exitWith { hint localize "STR_ATM_NotInGang"; }; // Überprüfe, ob der Spieler nicht in einer Gang ist
if (_value > 999999) exitWith { hint localize "STR_ATM_WithdrawMax"; };
if (_value < 1) exitWith {};
if (!([str(_value)] call life_util_fnc_isNumber)) exitWith { hint localize "STR_ATM_notnumeric"; };
if (_deposit && _value > CASH) exitWith { hint localize "STR_ATM_NotEnoughCash"; };
if (!_deposit && _value > _gFund) exitWith { hint localize "STR_ATM_NotEnoughFundsG"; };

// Führe den Abzug oder die Einzahlung durch
if (_deposit) then {
    CASH = CASH - _value;
    [] call life_fnc_atmMenu;
};

// Aktualisiere die Gangdatenbank
if (life_HC_isActive) then {
    [1, group player, _deposit, _value, player, CASH] remoteExecCall ["HC_fnc_updateGang", HC_Life];
} else {
    [1, group player, _deposit, _value, player, CASH] remoteExecCall ["TON_fnc_updateGang", RSERV];
};

// Setze die Action-Delay-Zeit
life_action_delay = time;
