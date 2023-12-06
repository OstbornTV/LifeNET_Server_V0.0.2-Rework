#include "\life_server\script_macros.hpp"
/*
    File: fn_addContainer.sqf
    Author: NiiRoZz

    Description:
    Fügt einen Container in die Datenbank ein.
*/

params [
    ["_uid", "", [""]],
    ["_container", objNull, [objNull]]
];

// Überprüfen, ob der Container oder die UID ungültig ist
if (isNull _container || {_uid isEqualTo ""}) exitWith {};

// Holen Sie die Position, den Klassennamen und die Ausrichtung des Containers
private _containerPos = getPosATL _container;
private _className = typeOf _container;
private _dir = [vectorDir _container, vectorUp _container];

// Erstellen Sie die Einfügeabfrage
private _query = format ["insertContainer:%1:%2:%3:%4", _uid, _containerPos, _className, _dir];

// Wenn der Debug-Modus aktiviert ist, geben Sie die Abfrage in das Diagnoseprotokoll aus
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log format ["Abfrage: %1", _query];
};

// Führen Sie die asynchrone Datenbankaktualisierung durch
[_query, 1] call DB_fnc_asyncCall;

// Kurze Pause für die Aktualisierung in der Datenbank
uiSleep 0.3;

// Holen Sie die Container-ID aus der Datenbank
_query = format ["selectContainerID:%1:%2", _containerPos, _uid];
_queryResult = [_query, 2] call DB_fnc_asyncCall;

// Setzen Sie die Container-ID als Variable im Container
_container setVariable ["container_id", _queryResult select 0, true];
