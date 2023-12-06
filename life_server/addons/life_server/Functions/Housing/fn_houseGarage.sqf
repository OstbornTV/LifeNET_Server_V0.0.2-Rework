#include "\life_server\script_macros.hpp"
/*
    File: fn_houseGarage.sqf
    Author: BoGuu
    Description:
    Datenbankfunktionalität für Garagen im Haus.
*/

params [
    ["_uid", "", [""]],
    ["_house", objNull, [objNull]],
    ["_mode", -1, [0]]
];

// Überprüfe die erforderlichen Parameter
if (_uid isEqualTo "" || {isNull _house} || {_mode isEqualTo -1}) exitWith {};

// Extrahiere die Position des Hauses
private _housePos = getPosATL _house;

// Setze den Aktivitätsstatus basierend auf dem Modus
private _active = ["0", "1"] select (_mode isEqualTo 0);

// Erstelle die Datenbankabfrage
private _query = format ["updateGarage:%1:%2:%3", _active, _uid, _housePos];

// Debug-Log für die Abfrage, falls Debug-Modus aktiviert ist
if (EXTDB_SETTING(getNumber, "DebugMode") isEqualTo 1) then {
    diag_log format ["Query: %1", _query];
}

// Führe die Datenbankabfrage asynchron aus
[_query, 1] call DB_fnc_asyncCall;
