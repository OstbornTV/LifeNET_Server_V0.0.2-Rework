#include "\life_hc\hc_macros.hpp"
/*
    Datei: fn_asyncCall.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Führt einen asynchronen Aufruf an ExtDB durch.

    Parameter:
        0: STRING (Abfrage, die ausgeführt werden soll).
        1: INTEGER (1 = ASYNC + kein Rückgabewert für Update/Insert, 2 = ASYNC + Rückgabewert für Abfragen).
        3: BOOL (True, um ein einzelnes Array zurückzugeben, false, um mehrere Einträge zurückzugeben, hauptsächlich für die Garage).
*/
private ["_queryStmt","_mode","_multiarr","_queryResult","_key","_return","_loop"];
_queryStmt = [_this, 0, "", [""]] call BIS_fnc_param;
_mode = [_this, 1, 1, [0]] call BIS_fnc_param;
_multiarr = [_this, 2, false, [false]] call BIS_fnc_param;

// Eindeutigen Schlüssel für die Anfrage erstellen
_key = format ["%1:%2:%3", _mode, FETCH_CONST(life_sql_id), _queryStmt];

// Beende die Funktion sofort, wenn es sich um einen asynchronen Aufruf ohne Rückgabewert handelt
if (_mode isEqualTo 1) exitWith { true };

// Extrahiere den Schlüssel aus dem Ergebnis der asynchronen Anfrage
_key = compile format ["%1", _key];
_key = (_key select 1);

// Ergebnis der Abfrage von ExtDB empfangen
_queryResult = format ["4:%1", _key];

// Stelle sicher, dass die Daten empfangen werden
if (_queryResult isEqualTo "[3]") then {
    for "_i" from 0 to 1 step 0 do {
        if (!(_queryResult isEqualTo "[3]")) exitWith {};
        _queryResult = EXTDB format ["4:%1", _key];
    };
}

// Behandele Mehrteilnachrichten von ExtDB
if (_queryResult isEqualTo "[5]") then {
    _loop = true;
    for "_i" from 0 to 1 step 0 do {
        _queryResult = "";
        for "_i" from 0 to 1 step 0 do {
            _pipe = EXTDB format ["5:%1", _key];
            if (_pipe isEqualTo "") exitWith { _loop = false };
            _queryResult = _queryResult + _pipe;
        };
        if (!_loop) exitWith {};
    };
}

// Ergebnis kompilieren und Fehlerprotokolle behandeln
_queryResult = compile _queryResult;
if ((_queryResult select 0) isEqualTo 0) exitWith { diag_log format ["extDB3: Protokollfehler: %1", _queryResult]; [] };

// Rückgabewert entsprechend Modus und Datenformatierung extrahieren
_return = (_queryResult select 1);
if (!_multiarr && count _return > 0) then {
    _return = (_return select 0);
}

// Rückgabewert zurückgeben
_return;
