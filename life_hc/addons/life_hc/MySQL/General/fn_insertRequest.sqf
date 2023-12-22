#include "\life_hc\hc_macros.hpp"
/*
    File: fn_insertRequest.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

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

// Fehlerüberprüfung
if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith {systemChat "Bad UID or name";}; // Lassen Sie den Clienten in einer 'verlorenen' 'Transaktion'
if (isNull _returnToSender) exitWith {systemChat "ReturnToSender is Null!";}; // Niemand, dem dies gesendet werden soll!

private _query = format ["checkPlayerExists:%1", _uid];
private _queryResult = [_query, 2] call HC_fnc_asyncCall;

// Doppelüberprüfung, um sicherzustellen, dass der Client nicht bereits in der Datenbank ist...
if (_queryResult isEqualType "" || {!(_queryResult isEqualTo [])}) exitWith {
    [] remoteExecCall ["SOCK_fnc_dataQuery", _returnToSender];
};

private _alias = [_name];

// Query-Statement vorbereiten
_query = format ["insertNewPlayer:%1:%2:%3:%4:%5",
    _uid,
    _name,
    _money,
    _bank,
    _alias
];

[_query, 1] call HC_fnc_asyncCall;
[] remoteExecCall ["SOCK_fnc_dataQuery", _returnToSender];
