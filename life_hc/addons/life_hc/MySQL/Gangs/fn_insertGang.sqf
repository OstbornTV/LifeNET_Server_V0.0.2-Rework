#include "\life_hc\hc_macros.hpp"
/*
    File: fn_insertGang.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Inserts the gang into the database.
*/
params [
    ["_ownerID", objNull, [objNull]],
    ["_uid", "", [""]],
    ["_gangName", "", [""]]
];

// Überprüfen, ob die erforderlichen Parameter gültig sind, andernfalls abbrechen
if (isNull _ownerID || {_uid isEqualTo ""} || {_gangName isEqualTo ""}) exitWith {};

// Gruppe des Eigentümers holen
private _group = group _ownerID;

// SQL-Abfrage, um zu überprüfen, ob der Gangname bereits existiert
private _query = format ["selectGangID:%1", _gangName];
private _queryResult = [_query, 2] call HC_fnc_asyncCall;

// Überprüfen, ob der Gangname bereits existiert
if (!(_queryResult isEqualTo [])) exitWith {
    [1, "Es existiert bereits ein Gang mit diesem Namen. Bitte wähle einen anderen Namen."] remoteExecCall ["life_fnc_broadcast", _ownerID];
    life_action_gangInUse = nil;
    _ownerID publicVariableClient "life_action_gangInUse";
};

// Überprüfen, ob die Person bereits einem Gang angehört oder diesen besitzt
private _uidLike = format ["%2%1%2", _uid, "%"];
_query = format ["selectGangIDFromMembers:%1", _uidLike];
_queryResult = [_query, 2] call HC_fnc_asyncCall;

if (!(count _queryResult isEqualTo 0)) exitWith {
    [1, "Du bist bereits in einem Gang aktiv. Bitte verlasse zuerst den Gang."] remoteExecCall ["life_fnc_broadcast", _ownerID];
    life_action_gangInUse = nil;
    _ownerID publicVariableClient "life_action_gangInUse";
};

// Überprüfen, ob ein inaktiver Gang mit diesem Namen existiert
_query = format ["selectInactiveGang:%1", _gangName];
_queryResult = [_query, 2] call HC_fnc_asyncCall;

private _gangMembers = [_uid];

// Entscheidung, ob der Gang aktualisiert oder eingefügt werden soll
if (!(_queryResult isEqualTo [])) then {
    _query = format ["updateGang:%1:%2:%3", (_queryResult select 0), _gangMembers, _uid];
} else {
    _query = format ["insertGang:%1:%2:%3", _uid, _gangName, _gangMembers];
};

// SQL-Abfrage ausführen
[_query, 1] call HC_fnc_asyncCall;

// Gang-Variablen setzen
_group setVariable ["gang_name", _gangName, true];
_group setVariable ["gang_owner", _uid, true];
_group setVariable ["gang_bank", 0, true];
_group setVariable ["gang_maxMembers", 8, true];
_group setVariable ["gang_members", [_uid], true];

// Funktion aufrufen, um die Gang-Erstellung zu behandeln
[_group] remoteExecCall ["life_fnc_gangCreated", _ownerID];

// Kurze Pause für die UI-Aktualisierung
uiSleep 0.35;

// Gang-ID abrufen und setzen
_query = format ["selectGangIDFromOwner:%1", _uid];
[_query, 2] call HC_fnc_asyncCall;
_group setVariable ["gang_id", (_queryResult select 0), true];
