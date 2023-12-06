#include "\life_server\script_macros.hpp"
/*
    File: fn_asyncCall.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Führt einen asynchronen Aufruf bei ExtDB durch.

    Parameters:
        0: STRING (Abfrage, die ausgeführt werden soll).
        1: INTEGER (1 = ASYNC + keine Rückgabe für Update/Insert, 2 = ASYNC + Rückgabe für Abfragen).
        3: BOOL (True für die Rückgabe eines einzelnen Arrays, false für die Rückgabe mehrerer Einträge, hauptsächlich für die Garage).
*/

params [
    ["_queryStmt", "", [""]],
    ["_mode", 1, [0]],
    ["_multiarr", false, [true]]
];

// Erstelle den eindeutigen Schlüssel für ExtDB
private _key = EXTDB format ["%1:%2:%3", _mode, FETCH_CONST(life_sql_id), _queryStmt];

// Beende die Funktion sofort, wenn der Modus 1 ist (ASYNC + keine Rückgabe für Update/Insert)
if (_mode isEqualTo 1) exitWith { true };

// Extrahiere den zweiten Teil des Schlüssels
_key = call compile format ["%1", _key];
_key = _key select 1;

// Fordere das Ergebnis von ExtDB an
private _queryResult = EXTDB format ["4:%1", _key];

// Stelle sicher, dass die Daten empfangen werden
if (_queryResult isEqualTo "[3]") then {
    for "_i" from 0 to 1 step 0 do {
        if (!(_queryResult isEqualTo "[3]")) exitWith {};
        _queryResult = EXTDB format ["4:%1", _key];
    };
}

// Wenn das Ergebnis "[5]" ist, handelt es sich um eine mehrteilige Nachricht
if (_queryResult isEqualTo "[5]") then {
    private _loop = true;
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

// Kompiliere das Ergebnis und überprüfe auf Fehler
_queryResult = call compile _queryResult;
if ((_queryResult select 0) isEqualTo 0) exitWith { diag_log format ["extDB3: Protocol Error: %1", _queryResult]; [] };

// Extrahiere den Rückgabewert
private _return = (_queryResult select 1);

// Wenn _multiarr false ist und _return nicht leer ist, extrahiere das erste Element
if (!_multiarr && {!(_return isEqualTo [])}) then {
    _return = _return select 0;
};

_return;
