/*
    File: fn_vehicleCreate.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Answers the query request to create the vehicle in the database.
*/

params [
    ["_uid", "", [""]],
    ["_side", sideUnknown, [west]],
    ["_vehicle", objNull, [objNull]],
    ["_color", -1, [0]]
];

// Fehlerüberprüfungen
if (_uid isEqualTo "" || {_side isEqualTo sideUnknown} || {isNull _vehicle || !alive _vehicle}) exitWith {};

// Extrahieren des Klassennamens des Fahrzeugs
private _className = typeOf _vehicle;

// Ermitteln des Fahrzeugtyps basierend auf der Klasse
private _type = switch (true) do {
    case (_vehicle isKindOf "Car"): {"Car"};
    case (_vehicle isKindOf "Air"): {"Air"};
    case (_vehicle isKindOf "Ship"): {"Ship"};
    default {""}; // Default-Fall hinzugefügt
};

// Übersetzung der Seite in die Rollenbezeichnung
private _sideString = switch (_side) do {
    case west:{"cop"};
    case civilian: {"civ"};
    case independent: {"med"};
    default {""}; // Default-Fall hinzugefügt
};

// Überprüfen auf leere Strings
if (_type isEqualTo "" || _sideString isEqualTo "") exitWith {};

// Zufällige Erzeugung einer Fahrzeugnummer
private _plate = round(random(1000000));

// Aufruf der Funktion zum Einfügen des Fahrzeugs in die Datenbank
[_uid, _sideString, _type, _className, _color, _plate] call HC_fnc_insertVehicle;

// Setzen von Fahrzeuginformationen als Variable
_vehicle setVariable ["dbInfo", [_uid, _plate], true];
