#include "\life_hc\hc_macros.hpp"

/*
    File: fn_chopShopSell.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Checks whether or not the vehicle is persistent or temp and sells it.
*/
params [
    ["_unit", objNull, [objNull]], // Einheit (Spieler)
    ["_vehicle", objNull, [objNull]], // Fahrzeug
    ["_price", 500, [0]] // Verkaufspreis (Standardwert: 500)
];

// Fehlerüberprüfungen
if (isNull _vehicle || isNull _unit) exitWith {
    // Beende das Skript und rufe die Funktion life_fnc_chopShopSold auf dem ausführenden Client auf
    [] remoteExecCall ["life_fnc_chopShopSold", remoteExecutedOwner];
};

// Holen Sie den Anzeigenamen des Fahrzeugs aus der Konfiguration
private _displayName = FETCH_CONFIG2(getText, "CfgVehicles", typeOf _vehicle, "displayName");

// Holen Sie die Datenbankinformationen des Fahrzeugs
private _dbInfo = _vehicle getVariable ["dbInfo", []];
if (count _dbInfo > 0) then {
    _dbInfo params ["_uid", "_plate"];
    private _query = format ["deleteVehicle:%1:%2", _uid, _plate];
    // Rufen Sie die asynchrone Datenbankanfrage auf, um das Fahrzeug aus der Datenbank zu löschen
    [_query, 1] call HC_fnc_asyncCall;
};

// Löschen Sie das Fahrzeug
deleteVehicle _vehicle;

// Informieren Sie das Client-Skript über den Verkauf des Fahrzeugs
[_price, _displayName] remoteExecCall ["life_fnc_chopShopSold", remoteExecutedOwner];
