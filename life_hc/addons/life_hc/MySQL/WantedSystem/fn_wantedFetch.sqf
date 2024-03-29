#include "\life_hc\hc_macros.hpp"

/*
    File: fn_wantedFetch.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Displays wanted list information sent from the server.
*/

params [
    ["_ret", objNull, [objNull]]  // Rückgabeobjekt, an das die Informationen übermittelt werden
];

if (isNull _ret) exitWith {};  // Beende das Skript, wenn das Rückgabeobjekt ungültig ist

private _inStatement = "";
private _list = [];
private _units = [];

// Sammle die Spieler-UIDs der zivilen Einheiten (Spielercharaktere)
{
    if (side _x isEqualTo civilian) then {
        _units pushBack (getPlayerUID _x);
    };
    false
} count playableUnits;

if (_units isEqualTo []) exitWith {[_list] remoteExec ["life_fnc_wantedList", _ret];};  // Wenn keine zivilen Einheiten gefunden wurden, rufe die Funktion life_fnc_wantedList auf dem Server auf

// Erstelle einen IN-Statement-String für die Datenbankabfrage
{
    if (count _units > 1) then {
        if (_inStatement isEqualTo "") then {
            _inStatement = "'" + _x + "'";
        } else {
            _inStatement = _inStatement + ", '" + _x + "'";
        };
    } else {
        _inStatement = _x;
    };
} forEach _units;

// Datenbankabfrage für aktive Verbrechen der gefundenen zivilen Einheiten
private _query = format ["selectWantedActiveID:%1", _inStatement];
private _queryResult = [_query, 2, true] call HC_fnc_asyncCall;  // Asynchrone Datenbankabfrage

// Debug-Logausgabe, wenn der Debug-Modus aktiviert ist
if (EXTDB_SETTING(getNumber, "DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1", _query];
};

// Füge die Ergebnisse der Datenbankabfrage zur Liste hinzu
{
    _list pushBack _x;
    false
} count _queryResult;

if (_list isEqualTo []) exitWith {[_list] remoteExec ["life_fnc_wantedList", _ret];};  // Wenn die Liste leer ist, rufe die Funktion life_fnc_wantedList auf dem Server auf

// Übermittle die Liste an die Funktion life_fnc_wantedList auf dem Server
[_list] remoteExec ["life_fnc_wantedList", _ret];
