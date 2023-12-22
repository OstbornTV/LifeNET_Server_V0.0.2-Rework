/*
    File: fn_vehicleDelete.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Doesn't actually delete since we don't give our DB user that type of
    access so instead we set it to alive=0 so it never shows again.
*/

params [
    ["_vid", -1, [0]], // Fahrzeug-ID (Standardwert: -1)
    ["_pid", "", [""]], // Spieler-ID
    ["_sp", 2500, [0]], // Spawn-Punkt (Standardwert: 2500)
    ["_unit", objNull, [objNull]], // Einheit (Spieler)
    ["_type", "", [""]] // Fahrzeugtyp
];

// Überprüfen auf leere oder ungültige Parameter
if (_vid isEqualTo -1 || {_pid isEqualTo ""} || {_sp isEqualTo 0} || {isNull _unit} || {_type isEqualTo ""}) exitWith {};

// Erstellen Sie die SQL-Abfrage zum Löschen des Fahrzeugs aus der Datenbank
private _query = format ["deleteVehicleID:%1:%2", _pid, _vid];

// Führen Sie die asynchrone Datenbankanfrage aus und erhalten Sie den Thread
private _thread = [_query, 1] call HC_fnc_asyncCall;
