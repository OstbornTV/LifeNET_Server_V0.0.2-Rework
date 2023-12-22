#include "..\..\script_macros.hpp"
/*
    File: fn_spawnPointSelected.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sorts out the spawn point selected and does a map zoom.
*/
// Deaktiviere die Serialisierung, um mögliche Probleme zu vermeiden
disableSerialization;

// Deklariere lokale Variablen
private ["_control", "_selection", "_spCfg", "_sp"];

// Extrahiere den Kontrollparameter
_control = [_this, 0, controlNull, [controlNull]] call BIS_fnc_param;
// Extrahiere die Auswahl des Spawnpunkts
_selection = [_this, 1, 0, [0]] call BIS_fnc_param;

// Rufe die Spawnpunkt-Konfiguration für die aktuelle Seite ab
_spCfg = [playerSide] call life_fnc_spawnPointCfg;
// Wähle den ausgewählten Spawnpunkt basierend auf der Auswahl
_sp = _spCfg select _selection;

// Setze die Kartenposition auf den ausgewählten Spawnpunkt
[((findDisplay 38500) displayCtrl 38502), 1, 0.1, getMarkerPos (_sp select 0)] call life_fnc_setMapPosition;
// Setze den globalen Spawnpunkt für den Spieler
life_spawn_point = _sp;

// Aktualisiere den Anzeigentext mit dem ausgewählten Spawnpunkt
ctrlSetText[38501, format ["%2: %1", _sp select 1, localize "STR_Spawn_CSP"]];
