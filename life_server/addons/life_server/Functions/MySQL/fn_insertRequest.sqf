#include "\life_server\script_macros.hpp"
/*
    File: fn_insertRequest.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Adds a player to the database upon the first joining of the server.
    Receives information from core\session\fn_insertPlayerInfo.sqf
*/

params [
    "_uid",
    "_name",
    ["_money", -1, [0]],
    ["_bank", -1, [0]],
    ["_returnToSender", objNull, [objNull]]
];

// Fehlerüberprüfungen
if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith { systemChat "Bad UID or name"; }; // Lass den Client in der 'Transaktion' 'verloren' gehen
if (isNull _returnToSender) exitWith { systemChat "ReturnToSender is Null!"; }; // Niemanden, dem das gesendet werden kann!

private _query = format ["checkPlayerExists:%1", _uid];
_tickTime = diag_tickTime;
private _queryResult = [_query, 2] call DB_fnc_asyncCall;

if (EXTDB_SETTING(getNumber, "DebugMode") isEqualTo 1) then {
    diag_log "------------- Insert Query Request -------------";
    diag_log format ["QUERY: %1", _query];
    diag_log format ["Time to complete: %1 (in seconds)", (diag_tickTime - _tickTime)];
    diag_log format ["Result: %1", _queryResult];
    diag_log "------------------------------------------------";
};

// Doppelüberprüfung, um sicherzustellen, dass der Client nicht bereits in der Datenbank ist...
if (_queryResult isEqualType "" && !(_queryResult isEqualTo [])) exitWith { [] remoteExecCall ["SOCK_fnc_dataQuery", (owner _returnToSender)]; };

private _alias = [_name];

// Bereite die Abfrageanweisung vor...
_query = format ["insertNewPlayer:%1:%2:%3:%4:%5",
    _uid,
    _name,
    _money,
    _bank,
    _alias
];

// Führe die Datenbank-Abfrage asynchron durch
[_query, 1] call DB_fnc_asyncCall;

// Sende eine Datenbankabfrage an den Client zurück
[] remoteExecCall ["SOCK_fnc_dataQuery", (owner _returnToSender)];
