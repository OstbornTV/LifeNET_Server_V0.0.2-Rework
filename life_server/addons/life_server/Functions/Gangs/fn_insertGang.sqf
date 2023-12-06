#include "\life_server\script_macros.hpp"
/*
    Datei: fn_insertGang.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Fügt die Gang in die Datenbank ein.
*/

// Parameter festlegen
params [
    ["_ownerID", objNull, [objNull]],  // Der Besitzer der Gang
    ["_uid", "", [""]],                // Die Eindeutige ID des Gang-Besitzers
    ["_gangName", "", [""]]            // Der Name der Gang
];

// Gruppenvariablen initialisieren
private _group = group _ownerID;

// Überprüfen, ob die Parameter gültig sind
if (isNull _ownerID || {_uid isEqualTo ""} || {_gangName isEqualTo ""}) exitWith {};

// Den Besitzer der Gang setzen
_ownerID = owner _ownerID;

// Überprüfen, ob der Gangname bereits existiert
private _query = format ["selectGangID:%1", _gangName];
private _queryResult = [_query, 2] call DB_fnc_asyncCall;

if !(_queryResult isEqualTo []) exitWith {
    [1, "Es gibt bereits eine Gang mit dem Namen"] remoteExecCall ["life_fnc_broadcast", _ownerID];
    life_action_gangInUse = nil;
    _ownerID publicVariableClient "life_action_gangInUse";
};

// Überprüfen, ob die Person bereits eine Gang besitzt oder Mitglied ist
private _uidLike = format["%2%1%2", _uid, "%"];
_query = format ["selectGangIDFromMembers:%1", _uidLike];
_queryResult = [_query, 2] call DB_fnc_asyncCall;

if (!(count _queryResult isEqualTo 0)) exitWith {
    [1, "Du bist gerade in einer Gang, verlasse diese zuerst"] remoteExecCall ["life_fnc_broadcast", _ownerID];
    life_action_gangInUse = nil;
    _ownerID publicVariableClient "life_action_gangInUse";
};

// Überprüfen, ob eine inaktive Gang mit dem Namen bereits existiert
_query = format ["selectInactiveGang:%1", _gangName];
_queryResult = [_query, 2] call DB_fnc_asyncCall;
private _gangMembers = [_uid];

if !(_queryResult isEqualTo []) then {
    _query = format ["updateGang:%1:%2:%3", (_queryResult select 0), _gangMembers, _uid];
} else {
    _query = format ["insertGang:%1:%2:%3", _uid, _gangName, _gangMembers];
};

// Gangdaten in die Datenbank einfügen
_queryResult = [_query, 1] call DB_fnc_asyncCall;

// Gruppenvariablen setzen
_group setVariable ["gang_name", _gangName, true];
_group setVariable ["gang_owner", _uid, true];
_group setVariable ["gang_bank", 0, true];
_group setVariable ["gang_maxMembers", 8, true];
_group setVariable ["gang_members", [_uid], true];
[_group] remoteExecCall ["life_fnc_gangCreated", _ownerID];

// Kurze Pause für die Aktualisierung
uiSleep 0.35;

// Gang-ID aus der Datenbank abrufen und setzen
_query = format ["selectGangIDFromOwner:%1", _uid];
_queryResult = [_query, 2] call DB_fnc_asyncCall;
_group setVariable ["gang_id", (_queryResult select 0), true];
