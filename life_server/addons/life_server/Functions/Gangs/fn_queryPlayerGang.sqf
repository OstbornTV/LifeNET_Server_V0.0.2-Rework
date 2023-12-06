/*
    File: fn_queryPlayerGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Abfrage, ob der Spieler einer Gang angehört.
*/

// Spieler-ID vorbereiten
private _pid = format ["%2%1%2", _this, "%"];

// Datenbankabfrage vorbereiten
private _query = format ["selectPlayerGang:%1", _pid];

// Asynchrone Datenbankabfrage durchführen
private _queryResult = [_query, 2] call DB_fnc_asyncCall;

// Ergebnis in der Missionsnamespace speichern
missionNamespace setVariable [format ["gang_%1", _this], _queryResult];
