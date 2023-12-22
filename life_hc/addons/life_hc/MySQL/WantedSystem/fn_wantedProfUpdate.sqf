#include "\life_hc\hc_macros.hpp"

/*
    File: fn_wantedProfUpdate.sqf
    Author: [midgetgrimm]
    Persistence by: ColinM

    This file is for Nanou's HeadlessClient.

    Description:
    Updates name of player if they change profiles
*/

params [
    ["_uid","",[""]],   // UID des Spielers, dessen Name aktualisiert werden soll
    ["_name","",[""]]   // Neuer Name des Spielers
];

// Überprüfung ungültiger Daten
if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith {};

// Datenbankabfrage, um den aktuellen Namen des Spielers aus der Wanted-Liste zu erhalten
private _wantedCheck = format ["selectWantedName:%1", _uid];
private _wantedQuery = [_wantedCheck, 2] call HC_fnc_asyncCall;

// Beende das Skript, wenn die Wanted-Abfrage keine Ergebnisse zurückgibt
if (_wantedQuery isEqualTo []) exitWith {};

// Überprüfen, ob der neue Name unterschiedlich vom aktuellen Namen ist
if !(_name isEqualTo (_wantedQuery select 0)) then {
    // Erstellen Sie eine Datenbankabfrage, um den Namen des Spielers in der Wanted-Liste zu aktualisieren
    private _query = format ["updateWantedName:%1:%2", _name, _uid];
    [_query, 2] call HC_fnc_asyncCall;  // Führen Sie eine asynchrone Datenbankabfrage durch, um den Namen zu aktualisieren
};
