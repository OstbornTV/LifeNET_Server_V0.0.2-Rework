/*
    File: fn_keyManagement.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Keeps track of an array locally on the server of a player's keys.
*/
private ["_uid", "_side", "_input", "_mode", "_arr"];

// Parameter erhalten
_uid = [_this, 0, "", [""]] call BIS_fnc_param;
_side = [_this, 1, sideUnknown, [sideUnknown]] call BIS_fnc_param;
_mode = [_this, 3, 0, [0]] call BIS_fnc_param;

// Überprüfen auf leere oder ungültige Parameter
if (_uid isEqualTo "" || _side isEqualTo sideUnknown) exitWith {};

// Hauptschalter für verschiedene Modi
switch (_mode) do {
    case 0: {
        // Modus 0: Aktualisieren der gesamten Schlüsselarray
        _input = [_this, 2, [], [[]]] call BIS_fnc_param;

        // Filtern von Null-Objekten
        _arr = _input - [objNull];

        // Aktualisieren des Schlüsselarrays im Missionsnamensraum
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], _arr];
    };

    case 1: {
        // Modus 1: Hinzufügen eines Schlüssels
        _input = [_this, 2, objNull, [objNull]] call BIS_fnc_param;

        // Überprüfen auf Null oder Hausobjekt
        if (isNull _input || _input isKindOf "House") exitWith {};

        // Holen des aktuellen Schlüsselarrays
        _arr = missionNamespace getVariable [format ["%1_KEYS_%2", _uid, _side], []];

        // Hinzufügen des neuen Schlüssels und Filtern von Null-Objekten
        _arr = _arr - [objNull, _input];

        // Aktualisieren des Schlüsselarrays im Missionsnamensraum
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], _arr];
    };

    case 2: {
        // Modus 2: Löschen aller Schlüssel
        // Setzen des Schlüsselarrays im Missionsnamensraum auf ein leeres Array
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], []];
    };
};
