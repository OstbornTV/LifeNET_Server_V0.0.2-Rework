#include "..\..\script_macros.hpp"
/*
    File: fn_gangUpgrade.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Bestimmt den Upgrade-Preis und mehr.
*/
// Deklariere lokale Variablen
private ["_maxMembers","_slotUpgrade","_upgradePrice"];
// Erhalte die maximale Anzahl von Gangmitgliedern aus den Gruppenvariablen des Spielers
_maxMembers = group player getVariable ["gang_maxMembers",8];
// Berechne die Anzahl der neuen Slots nach dem Upgrade
_slotUpgrade = _maxMembers + 4;
// Berechne den Upgrade-Preis basierend auf der Konfiguration
_upgradePrice = round(_slotUpgrade * ((LIFE_SETTINGS(getNumber,"gang_upgradeBase"))) / ((LIFE_SETTINGS(getNumber,"gang_upgradeMultiplier"))));

// Zeige eine Bestätigungsnachricht an
_action = [
    format [
        (localize "STR_GNOTF_MaxMemberMSG") +
        "<br/><br/>" +
        (localize "STR_GNOTF_CurrentMax") +
        "<br/>" +
        (localize "STR_GNOTF_UpgradeMax") +
        "<br/>" +
        (localize "STR_GNOTF_Price") +
        " <t color='#8cff9b'>$%3</t>",
        _maxMembers,
        _slotUpgrade,
        [_upgradePrice] call life_fnc_numberText
    ],
    localize "STR_Gang_UpgradeMax",
    localize "STR_Global_Buy",
    localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

// Führe die Aktion durch, wenn der Spieler zustimmt
if (_action) then {
    // Breche ab, wenn der Spieler nicht genügend Geld hat
    if (BANK < _upgradePrice) exitWith {
        hint parseText format [
            (localize "STR_GNOTF_NotEoughMoney_2") +
            "<br/><br/>" +
            (localize "STR_GNOTF_Current") +
            " <t color='#8cff9b'>$%1</t>" +
            "<br/>" +
            (localize "STR_GNOTF_Lacking") +
            " <t color='#FF0000'>$%2</t>",
            [BANK] call life_fnc_numberText,
            [_upgradePrice - BANK] call life_fnc_numberText
        ];
    };
    // Ziehe den Upgrade-Preis vom Bankkonto des Spielers ab
    BANK = BANK - _upgradePrice;
    // Aktualisiere die Bankdaten im Datenbank- und HUD-System
    [1] call SOCK_fnc_updatePartial;
    // Setze die maximale Anzahl von Gangmitgliedern in den Gruppenvariablen des Spielers
    group player setVariable ["gang_maxMembers",_slotUpgrade,true];
    // Zeige eine Erfolgsmeldung an
    hint parseText format [localize "STR_GNOTF_UpgradeSuccess",_maxMembers,_slotUpgrade,[_upgradePrice] call life_fnc_numberText];

    // Aktualisiere die Gangdatenbank
    if (life_HC_isActive) then {
        [2,group player] remoteExec ["HC_fnc_updateGang",HC_Life];
    } else {
        [2,group player] remoteExec ["TON_fnc_updateGang",RSERV];
    };

} else {
    // Zeige eine Meldung an, dass der Vorgang abgebrochen wurde
    hint localize "STR_GNOTF_UpgradeCancel";
};