#include "\life_hc\hc_macros.hpp"

/*
    File: fn_wantedPerson.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Fetches a specific person from the wanted array.
*/

params [
    ["_unit", objNull, [objNull]]  // Die Einheit (Spielercharakter), für die die Informationen abgerufen werden sollen
];

if (isNull _unit) exitWith {[]};  // Beende das Skript, wenn die Einheit ungültig ist

private _uid = getPlayerUID _unit;  // Holen Sie die UID der Einheit
private _query = format ["selectWantedBounty:%1", _uid];  // Erstellen Sie eine Datenbankabfrage für die spezifische Person
private _queryResult = [_query,2] call HC_fnc_asyncCall;  // Führen Sie eine asynchrone Datenbankabfrage durch

_queryResult;  // Rückgabe der Ergebnisse der Datenbankabfrage
