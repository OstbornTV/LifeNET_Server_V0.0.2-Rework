#include "\life_hc\hc_macros.hpp"

/*
    File: fn_getVehicles.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Sends a request to query the database information and returns vehicles.
*/
params [
    ["_pid", "", [""]], // Spieler-ID
    ["_side", sideUnknown, [west]], // Fraktion des Spielers (west als Standardwert)
    ["_type", "", [""]], // Fahrzeugtyp
    ["_unit", objNull, [objNull]] // Einheit (Spieler)
];

// Fehlerüberprüfungen
if (_pid isEqualTo "" || {_side isEqualTo sideUnknown} || {_type isEqualTo ""} || {isNull _unit}) exitWith {
    if (!isNull _unit) then {
        // Wenn das _unit-Objekt nicht null ist, rufe die Funktion life_fnc_impoundMenu auf dem Client auf
        [[]] remoteExec ["life_fnc_impoundMenu", _unit];
    };
};

// Konvertieren Sie _side in eine geeignete Zeichenkette
_side = switch (_side) do {
    case west:{"cop"};
    case civilian: {"civ"};
    case independent: {"med"};
    default {"Error"};
};

// Überprüfen Sie, ob ein Fehler bei der Umwandlung von _side aufgetreten ist
if (_side isEqualTo "Error") exitWith {
    if (!isNull _unit) then {
        // Wenn das _unit-Objekt nicht null ist, rufe die Funktion life_fnc_impoundMenu auf dem Client auf
        [[]] remoteExec ["life_fnc_impoundMenu", _unit];
    };
};

// Erstellen Sie die Datenbankabfrage
private _query = format ["selectVehicles:%1:%2:%3", _pid, _side, _type];

// Führen Sie die asynchrone Datenbankanfrage aus und erhalten Sie das Ergebnis
private _queryResult = [_query, 2, true] call HC_fnc_asyncCall;

// Überprüfen Sie, ob das Ergebnis gültig ist
if (_queryResult isEqualType "") exitWith {
    if (!isNull _unit) then {
        // Wenn das _unit-Objekt nicht null ist, rufe die Funktion life_fnc_impoundMenu auf dem Client auf
        [[]] remoteExec ["life_fnc_impoundMenu", _unit];
    };
};

// Rufen Sie die Funktion life_fnc_impoundMenu auf dem Client auf und übergeben Sie das Ergebnis der Datenbankabfrage
[_queryResult] remoteExec ["life_fnc_impoundMenu", _unit];
