#include "..\..\script_macros.hpp"
/*
    File: fn_pickupMoney.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Picks up money
*/
params [
    ["_money", objNull, [objNull]]
];

// Verzögerung für die Aktion
if ((time - life_action_delay) < 1.5) exitWith {
    hint localize "STR_NOTF_ActionDelay";
    _money setVariable ["inUse", false, true];
};

// Überprüfe, ob das Geldobjekt existiert und in der Nähe des Spielers ist
if (isNull _money || { player distance _money > 3 }) exitWith {
    _money setVariable ["inUse", false, true];
};

// Holen Sie sich den Geldbetrag
private _value = (_money getVariable "item") select 1;

// Überprüfen Sie, ob der Geldbetrag gültig ist
if (!isnil "_value") exitWith {
    // Lösche das Geldobjekt
    deleteVehicle _money;

    // Begrenze den abgehobenen Betrag basierend auf den Einstellungen
    private _pickupLimit = LIFE_SETTINGS(getNumber, "cash_pickup_limit");
    _value = _value min _pickupLimit;

    // Spiele die Bewegung ab und aktualisiere den Anzeigetext
    player playMove "AinvPknlMstpSlayWrflDnon";
    titleText [format [localize "STR_NOTF_PickedMoney", [_value] call life_fnc_numberText], "PLAIN"];
    
    // Aktualisiere das Bargeld und sende eine Aktualisierung an den Server
    CASH = CASH + _value;
    [0] call SOCK_fnc_updatePartial;
    life_action_delay = time;

    // Geldtransaktionsprotokoll für erweiterte Protokollierung
    if (LIFE_SETTINGS(getNumber, "player_moneylog") isEqualTo 1) then {
        if (LIFE_SETTINGS(getNumber, "battlEye_friendlyLogging") isEqualTo 1) then {
            money_log = format [localize "STR_DL_ML_PickedUpMoney_BEF", [_value] call life_fnc_numberText, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
        } else {
            money_log = format [localize "STR_DL_ML_PickedUpMoney", profileName, (getPlayerUID player), [_value] call life_fnc_numberText, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
        };
        publicVariableServer "money_log";
    };
};
