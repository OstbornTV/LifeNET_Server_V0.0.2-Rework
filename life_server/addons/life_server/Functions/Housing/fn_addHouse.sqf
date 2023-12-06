#include "\life_server\script_macros.hpp"
/*
    File: fn_addHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Fügt das neu gekaufte Haus des Spielers in die Datenbank ein.
*/

params [
    ["_uid","",[""]],
    ["_house",objNull,[objNull]]
];

// Überprüfen, ob das Haus oder die UID ungültig ist
if (isNull _house || {_uid isEqualTo ""}) exitWith {};

// Holen Sie die Position des Hauses
private _housePos = getPosATL _house;

// Erstellen Sie die Einfügeabfrage
private _query = format ["insertHouse:%1:%2", _uid, _housePos];

// Wenn der Debug-Modus aktiviert ist, geben Sie die Abfrage in das Diagnoseprotokoll aus
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log format ["Abfrage: %1",_query];
};

// Führen Sie die asynchrone Datenbankaktualisierung durch
[_query, 1] call DB_fnc_asyncCall;

// Kurze Pause für die Aktualisierung in der Datenbank
uiSleep 0.3;

// Holen Sie die Haus-ID aus der Datenbank
_query = format ["selectHouseID:%1:%2", _housePos, _uid];
_queryResult = [_query, 2] call DB_fnc_asyncCall;

// Setzen Sie die Haus-ID als Variable im Haus
_house setVariable ["house_id", _queryResult select 0, true];
