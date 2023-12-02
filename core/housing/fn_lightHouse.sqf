#include "..\..\script_macros.hpp"
/*
    Datei: fn_lightHouse.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Teilt den Clients mit, ob sie das Licht für dieses Haus einschalten oder ausschalten sollen.
*/

private ["_lightSource", "_exit"];

// Parameter definieren
params [
    ["_house", objNull, [objNull]],
    ["_mode", false, [false]]
];

// Beende das Skript, wenn das übergebene Hausobjekt null ist.
if (isNull _house) exitWith {};

// Beende das Skript, wenn das übergebene Objekt kein Haus ist.
if (!(_house isKindOf "House_F")) exitWith {};

_exit = false;

// Überprüfe den Modus
if (_mode) then {
    // Lichtquelle erstellen und am Haus befestigen
    _lightSource = "#lightpoint" createVehicleLocal [0, 0, 0];
    _lightSource lightAttachObject [_house, (getArray (missionConfigFile >> "Housing" >> worldName >> (typeOf _house) >> "lightPos"))];
    _lightSource setLightColor [250, 150, 50];
    _lightSource setLightAmbient [1, 1, 0.2];
    _lightSource setLightAttenuation [1, 0, 0, 0];
    _lightSource setLightIntensity 10;
    _lightSource setLightUseFlare true;
    _lightSource setLightFlareSize 0.2;
    _lightSource setLightFlareMaxDistance 50;

    // Setze die Lichtquelle als Variable für das Haus
    _house setVariable ["lightSource", _lightSource];
} else {
    // Beende das Skript, wenn die Lichtquelle des Hauses null ist.
    if (isNull (_house getVariable ["lightSource", objNull])) exitWith {};

    // Lösche die Lichtquelle des Hauses
    deleteVehicle (_house getVariable ["lightSource", objNull]);
};
