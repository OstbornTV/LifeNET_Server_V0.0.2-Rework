/*
    File: fn_queryPlayerGang.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Queries to see if the player belongs to any gang.
*/

private ["_pid", "_query", "_queryResult"];

// Spieler-ID oder eindeutiger Spielerbezeichner vorbereiten
_pid = format ["%2%1%2", _this, "%"];

// SQL-Abfrage vorbereiten
_query = format ["selectPlayerGang:%1", _pid];

// Asynchrone Ausführung der Abfrage über den HeadlessClient
_queryResult = [_query, 2] call HC_fnc_asyncCall;

// Ergebnis der Abfrage im Mission-Namespace speichern
missionNamespace setVariable [format ["gang_%1", _this], call HC_fnc_processQueryResult];
