#include "\life_hc\hc_macros.hpp"
/*
    File: fn_updateGang.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Updates the gang information?
*/

params [
    ["_mode", 0, [0]],
    ["_group", grpNull, [grpNull]]
];

// Fehlerbehandlung, wenn _group ungültig ist
if (isNull _group) exitWith {"Error: Invalid group."};

// Gang-ID aus den Gruppenvariablen abrufen
private _groupID = _group getVariable ["gang_id", -1];

// Fehlerbehandlung, wenn gang_id ungültig ist
if (_groupID isEqualTo -1) exitWith {"Error: Invalid gang ID."};

private "_query";

// Schalter für verschiedene Aktualisierungsmodi
switch (_mode) do {
    case 0: {
        // Modus 0: Gang-Informationen aktualisieren
        private _bank = _group getVariable ["gang_bank", 0];
        private _maxMembers = _group getVariable ["gang_maxMembers", 8];
        private _owner = _group getVariable ["gang_owner", ""];

        // Fehlerbehandlung, wenn gang_owner ungültig ist
        if (_owner isEqualTo "") exitWith {"Error: Invalid gang owner."};

        _query = format ["updateGang1:%1:%2:%3:%4", _bank, _maxMembers, _owner, _groupID];
    };

    case 1: {
        // Modus 1: Gang-Kontostand aktualisieren
        params [
            "",
            "",
            ["_deposit", false, [false]],
            ["_value", 0, [0]],
            ["_unit", objNull, [objNull]],
            ["_cash", 0, [0]]
        ];

        private _funds = _group getVariable ["gang_bank",0];
        if (_deposit) then {
            _funds = _funds + _value;
            _group setVariable ["gang_bank",_funds,true];
            [1,"STR_ATM_DepositSuccessG",true,[_value]] remoteExecCall ["life_fnc_broadcast",remoteExecutedOwner];
        } else {
            if (_value > _funds) exitWith {
                [1,"STR_ATM_NotEnoughFundsG",true] remoteExecCall ["life_fnc_broadcast",remoteExecutedOwner];
                breakOut "";
            };
            _funds = _funds - _value;
            _group setVariable ["gang_bank",_funds,true];
            [_value] remoteExecCall ["life_fnc_gangBankResponse",remoteExecutedOwner];
            _cash = _cash + _value;
        };
        if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
            if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
                diag_log (format [localize "STR_DL_ML_withdrewGang_BEF",_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            } else {
                diag_log (format [localize "STR_DL_ML_withdrewGang",name _unit,(getPlayerUID _unit),_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            };
        };
        [getPlayerUID _unit,side _unit,_cash,0] call HC_fnc_updatePartial;

        _query = format ["updateGangBank:%1:%2", _group getVariable ["gang_bank", 0], _groupID];
    };

    case 2: {
        // Modus 2: Maximale Anzahl der Gangmitglieder aktualisieren
        _query = format ["updateGangMaxmembers:%1:%2", (_group getVariable ["gang_maxMembers", 8]), _groupID];
    };

    case 3: {
        // Modus 3: Gangbesitzer aktualisieren
        private _owner = _group getVariable ["gang_owner", ""];

        // Fehlerbehandlung, wenn gang_owner ungültig ist
        if (_owner isEqualTo "") exitWith {"Error: Invalid gang owner."};

        _query = format ["updateGangOwner:%1:%2", _owner, _groupID];
    };

    case 4: {
        // Modus 4: Gangmitglieder aktualisieren
        private _members = _group getVariable "gang_members";
        private "_membersFinal";

        // Überprüfen, ob die Anzahl der Mitglieder die maximale Anzahl überschreitet
        if (count _members > (_group getVariable ["gang_maxMembers", 8])) then {
            _membersFinal = _members select [0, (_group getVariable ["gang_maxMembers", 8]) - 1];
        } else {
            _membersFinal = _members;
        };

        _query = format ["updateGangMembers:%1:%2", _membersFinal, _groupID];
    };
};

// Wenn die Query-Variable nicht null ist, die Datenbankanfrage über den HeadlessClient ausführen
if (!isNil "_query") then {
    [_query, 1] call HC_fnc_asyncCall;
};
