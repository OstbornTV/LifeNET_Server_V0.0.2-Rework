/*
    File: fn_wantedRemove.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Removes a person from the wanted list.
*/

params [
    ["_uid", "", [""]]   // UID der Person, die aus der Wanted-Liste entfernt werden soll
];

if (_uid isEqualTo "") exitWith {}; // Überprüfung ungültiger Daten: Beende das Skript, wenn die UID ungültig ist

// Erstellen Sie eine Datenbankabfrage, um die Person mit der angegebenen UID aus der Wanted-Liste zu entfernen
private _query = format ["deleteWanted:%1", _uid];

// Führen Sie eine asynchrone Datenbankabfrage durch, um die Person zu entfernen
[_query, 2] call HC_fnc_asyncCall;
