#include "..\..\script_macros.hpp"
/*
    File: fn_spawnMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initialisiert das Menü zur Auswahl des Spawnpunkts.
*/
private ["_spCfg", "_sp", "_ctrl"];
disableSerialization;

// Überprüfen, ob der Spieler verhaftet ist
if (life_is_arrested) exitWith {
    [] call life_fnc_respawned;
};

// Überprüfen, ob der Spieler bereits gespawnt ist
if (life_respawned) then {
    [] call life_fnc_respawned;
};

// Bildschirm schwarz ausblenden
cutText ["","BLACK FADED"];
0 cutFadeOut 9999999;

// Dialog erstellen und Handler festlegen
if (!(createDialog "life_spawn_selection")) exitWith {[] call life_fnc_spawnMenu;};
(findDisplay 38500) displaySetEventHandler ["keyDown","_this call life_fnc_displayHandler"];

// Konfiguration für die Spawnpunkte abrufen
_spCfg = [playerSide] call life_fnc_spawnPointCfg;

// UI-Element für die Spawnpunkte vorbereiten
_ctrl = ((findDisplay 38500) displayCtrl 38510);
{
    _ctrl lnbAddRow[(_spCfg select _forEachIndex) select 1, (_spCfg select _forEachIndex) select 0, ""];
    _ctrl lnbSetPicture[[_forEachIndex, 0], (_spCfg select _forEachIndex) select 2];
    _ctrl lnbSetData[[_forEachIndex, 0], (_spCfg select _forEachIndex) select 0];
} forEach _spCfg;

// Standardmäßig den ersten Spawnpunkt auswählen
_sp = _spCfg select 0;

// Karte auf den ausgewählten Spawnpunkt setzen
[((findDisplay 38500) displayCtrl 38502), 1, 0.1, getMarkerPos (_sp select 0)] call life_fnc_setMapPosition;

// Aktuellen Spawnpunkt setzen
life_spawn_point = _sp;

// Text für ausgewählten Spawnpunkt anzeigen
ctrlSetText[38501, format ["%2: %1", _sp select 1, localize "STR_Spawn_CSP"]];
