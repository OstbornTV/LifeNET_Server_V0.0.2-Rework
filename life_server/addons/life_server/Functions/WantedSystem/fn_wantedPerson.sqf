/*
    File: fn_wantedPerson.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Fetches information for a specific person from the wanted array.
*/

params [
    ["_unit", objNull, [objNull]]
];

// Sicherstellen, dass _unit nicht null ist
if (isNull _unit) exitWith {[]};

// Spieler-ID für die Datenbankabfrage erhalten
private _uid = getPlayerUID _unit;

// Datenbankabfrage durchführen
private _query = format ["selectWantedBounty:%1", _uid];
private _queryResult = [_query, 2] call DB_fnc_asyncCall;

// Wenn die Datenbankantwort leer ist, leere Liste zurückgeben
if (_queryResult isEqualTo []) exitWith {[]};

// Die Ergebnisse der Datenbankabfrage zurückgeben
_queryResult;
