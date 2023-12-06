#include "\life_server\script_macros.hpp"
/*
    File: fn_updateGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Aktualisiert die Gang-Informationen
*/

params [
    ["_mode", 0, [0]],
    ["_group", grpNull, [grpNull]]
];

// Wenn die Gruppe ungültig ist, beende die Funktion
if (isNull _group) exitWith {};

// Hole die Gang-ID aus den Gruppenvariablen
private _groupID = _group getVariable ["gang_id", -1];

// Wenn die Gang-ID ungültig ist, beende die Funktion
if (_groupID isEqualTo -1) exitWith {};

private "_query";

// Verwende einen Switch-Case für verschiedene Aktualisierungsmodi
switch (_mode) do {
    case 0: {
        // Modus 0: Allgemeine Gang-Informationen aktualisieren
        private _bank = _group getVariable ["gang_bank", 0];
        private _maxMembers = _group getVariable ["gang_maxMembers", 8];
        private _members = _group getVariable "gang_members";
        private _owner = _group getVariable ["gang_owner", ""];
        
        // Wenn der Besitzer ungültig ist, beende die Funktion
        if (_owner isEqualTo "") exitWith {};

        // Erstelle die Aktualisierungsabfrage
        _query = format ["updateGang1:%1:%2:%3:%4", _bank, _maxMembers, _owner, _groupID];
    };

    case 1: {
        // Modus 1: Gang-Kasse aktualisieren
        params [
            "",
            "",
            ["_deposit", false, [false]],
            ["_value", 0, [0]],
            ["_unit", objNull, [objNull]],
            ["_cash", 0, [0]]
        ];

        // Holen Sie die aktuellen Gelder aus der Gang-Kasse
        private _funds = _group getVariable ["gang_bank", 0];

        // Verarbeite die Einzahlung oder Abhebung
        if (_deposit) then {
            _funds = _funds + _value;
            _group setVariable ["gang_bank", _funds, true];
            [1, "STR_ATM_DepositSuccessG", true, [_value]] remoteExecCall ["life_fnc_broadcast", remoteExecutedOwner];
        } else {
            // Überprüfen Sie, ob genügend Geld vorhanden ist
            if (_value > _funds) exitWith {
                [1, "STR_ATM_NotEnoughFundsG", true] remoteExecCall ["life_fnc_broadcast", remoteExecutedOwner];
                breakOut "";
            };

            // Aktualisieren Sie die Gelder und führen Sie andere Aktionen durch
            _funds = _funds - _value;
            _group setVariable ["gang_bank", _funds, true];
            [_value] remoteExecCall ["life_fnc_gangBankResponse", remoteExecutedOwner];
            _cash = _cash + _value;
        };

        if (LIFE_SETTINGS(getNumber,"player_moneyLog") isEqualTo 1) then {
            if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
                diag_log (format [localize "STR_DL_ML_withdrewGang_BEF",_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            } else {
                diag_log (format [localize "STR_DL_ML_withdrewGang",name _unit,(getPlayerUID _unit),_value,[_funds] call life_fnc_numberText,[0] call life_fnc_numberText,[_cash] call life_fnc_numberText]);
            };
        };
        
        // Führen Sie eine Datenbankaktualisierung durch und erstellen Sie die Aktualisierungsabfrage
        [getPlayerUID _unit, side _unit, _cash, 0] call DB_fnc_updatePartial;
        _query = format ["updateGangBank:%1:%2", _group getVariable ["gang_bank", 0], _groupID];
    };

    case 2: {
        // Modus 2: Maximale Anzahl von Gangmitgliedern aktualisieren
        _query = format ["updateGangMaxmembers:%1:%2", (_group getVariable ["gang_maxMembers", 8]), _groupID];
    };

    case 3: {
        // Modus 3: Gangbesitzer aktualisieren
        private _owner = _group getVariable ["gang_owner", ""];
        if (_owner isEqualTo "") exitWith {};
        _query = format ["updateGangOwner:%1:%2", _owner, _groupID];
    };

    case 4: {
        // Modus 4: Gangmitglieder aktualisieren
        private _members = _group getVariable "gang_members";
        private "_membersFinal";

        // Überprüfen Sie, ob die Anzahl der Mitglieder die maximale Anzahl überschreitet
        if (count _members > (_group getVariable ["gang_maxMembers", 8])) then {
            _membersFinal = [];
            for "_i" from 0 to _maxMembers - 1 do {
                _membersFinal pushBack (_members select _i);
            };
        } else {
            _membersFinal = _group getVariable "gang_members";
        };

        // Erstellen Sie die Aktualisierungsabfrage
        _query = format ["updateGangMembers:%1:%2", _membersFinal, _groupID];
    };
};

// Wenn die Aktualisierungsabfrage nicht leer ist, führen Sie die asynchrone Datenbankaktualisierung durch
if (!isNil "_query") then {
    [_query, 1] call DB_fnc_asyncCall;
};
