/*
    File: fn_insertVehicle.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Inserts the vehicle into the database
*/

params [
    "_uid",
    "_side",
    "_type",
    "_className",
    ["_color", -1, [0]],
    ["_plate", -1, [0]]
];

// Stopp unzulässige Daten von der Übermittlung.
if (_uid isEqualTo "" || {_side isEqualTo ""} || {_type isEqualTo ""} || {_className isEqualTo ""} || {_color isEqualTo -1} || {_plate isEqualTo -1}) exitWith {};

// Bereite die Abfrageanweisung vor.
private _query = format ["insertVehicle:%1:%2:%3:%4:%5:%6", _side, _className, _type, _uid, _color, _plate];

// Führe den asynchronen Datenbankaufruf aus.
[_query, 1] call HC_fnc_asyncCall;
