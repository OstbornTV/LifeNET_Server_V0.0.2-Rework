#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedFetch.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Displays wanted list information sent from the server.
*/

params [
    ["_ret", objNull, [objNull]]
];

// Sicherstellen, dass _ret nicht null ist
if (isNull _ret) exitWith {};

// Den Eigentümer von _ret erhalten
_ret = owner _ret;

// Spieler-IDs für den Zivilisten-Seitenfilter erhalten
private _units = [];
{
    if (side _x isEqualTo civilian) then {
        _units pushBack (getPlayerUID _x);
    };
    false
} count playableUnits;

// Wenn keine Zivilisten gefunden wurden, die Liste senden und beenden
if (_units isEqualTo []) exitWith {
    [_list] remoteExec ["life_fnc_wantedList", _ret];
};

// Erstellen des IN-Statements für die Datenbankabfrage
private _inStatement = toArrayStringQuoted _units;

// Datenbankabfrage durchführen
private _query = format ["selectWantedActiveID:%1", _inStatement];
private _queryResult = [_query, 2, true] call DB_fnc_asyncCall;

// Debug-Ausgabe für die Abfrage
if (EXTDB_SETTING(getNumber, "DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1", _query];
}

// Spieler-IDs in eine Liste einfügen
private _list = [];
{
    _list pushBack _x;
    false
} count _queryResult;

// Wenn die Liste leer ist, sende die leere Liste und beende
if (_list isEqualTo []) exitWith {
    [_list] remoteExec ["life_fnc_wantedList", _ret];
};

// Senden der Liste an die Funktion life_fnc_wantedList auf dem Client
[_list] remoteExec ["life_fnc_wantedList", _ret];

