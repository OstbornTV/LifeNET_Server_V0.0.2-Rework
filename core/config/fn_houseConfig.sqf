#include "..\..\script_macros.hpp"
/*
    File: fn_houseConfig.sqf
    Author: BoGuu

    Description:
    Fetch data from Config_Housing/Garages
*/

params [
    ["_house", "", [""]]
];

// Überprüfen, ob _house leer ist
if (_house isEqualTo "") exitWith {[]};

// Konfigurationsdaten für das Haus und die Garage erhalten
private _houseConfig = missionConfigFile >> "Housing" >> worldName >> _house;
private _garageConfig = missionConfigFile >> "Garages" >> worldName >> _house;

// Überprüfen, ob beide Konfigurationen Klassen sind
private _config = [_garageConfig, _houseConfig] select {isClass _x};

// Exit, wenn keine gültige Konfiguration gefunden wurde
if (_config isEqualTo []) exitWith {[]};

// Die Garage-Konfiguration auswählen
_config = _config select 0;

// Preis und Anzahl der Kisten aus der Konfiguration extrahieren
private _price = getNumber(_config >> "price");
private _numberCrates = if (_houseConfig isEqualTo _config) then {getNumber(_houseConfig >> "numberCrates")} else {0};

// Rückgabewert
[_price, _numberCrates]
