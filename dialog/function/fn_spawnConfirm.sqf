#include "..\..\script_macros.hpp"
/*
    File: fn_spawnConfirm.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Spawnt den Spieler an seinem ausgewählten Ort.
*/
// Dialog schließen und schwarzen Bildschirm anzeigen
private ["_spCfg", "_sp", "_spawnPos"];
closeDialog 0;
cutText ["","BLACK IN"];

// Überprüfen, ob ein spezifischer Spawnpunkt ausgewählt wurde
if (life_spawn_point isEqualTo []) then {
    private ["_sp", "_spCfg"];
    // Spawnpunkt-Konfiguration basierend auf der Fraktion abrufen
    _spCfg = [playerSide] call life_fnc_spawnPointCfg;
    _sp = _spCfg select 0;

    // Überprüfen, ob es sich um einen Zivilisten handelt
    if (playerSide isEqualTo civilian) then {
        if (isNil {(call compile format ["%1", _sp select 0])}) then {
            // Wenn kein spezifischer Punkt vorhanden ist, Zufälligen Punkt auswählen
            player setPos (getMarkerPos (_sp select 0));
        } else {
            // Wenn spezifische Punkte vorhanden sind, Zufälligen Punkt in einem Gebäude auswählen
            _spawnPos = selectRandom (call compile format ["%1", _sp select 0]);
            _spawnPos = _spawnPos buildingPos 0;
            player setPos _spawnPos;
        };
    } else {
        // Wenn es sich nicht um einen Zivilisten handelt, Spieler an festgelegten Punkt setzen
        player setPos (getMarkerPos (_sp select 0));
    };

    // Erfolgsmeldung anzeigen
    titleText[format ["%2 %1", _sp select 1, localize "STR_Spawn_Spawned"], "BLACK IN"];
} else {
    // Wenn ein spezifischer Punkt ausgewählt wurde
    if (playerSide isEqualTo civilian) then {
        if (isNil {(call compile format ["%1", life_spawn_point select 0])}) {
            // Wenn kein spezifischer Punkt vorhanden ist
            if (((life_spawn_point select 0) find "house") != -1) then {
                // Wenn der Punkt in einem Gebäude ist, Zufälligen Punkt im Gebäude auswählen
                private ["_bPos", "_house", "_pos"];
                _house = nearestObjects [getMarkerPos (life_spawn_point select 0), ["House_F"], 10] select 0;
                _bPos = [_house] call life_fnc_getBuildingPositions;

                // Exit, wenn keine Positionen im Gebäude gefunden wurden
                if (_bPos isEqualTo []) exitWith {
                    player setPos (getMarkerPos (life_spawn_point select 0));
                };

                // Positionen von Gebäudeteilen abziehen, die von Spielern besetzt sind
                {_bPos = _bPos - [(_house buildingPos _x)];} forEach (_house getVariable ["slots",[]]);
                // Zufällige Position im Gebäude auswählen
                _pos = selectRandom _bPos;
                player setPosATL _pos;
            } else {
                // Wenn kein Gebäude, Spieler an festgelegten Punkt setzen
                player setPos (getMarkerPos (life_spawn_point select 0));
            };
        } else {
            // Wenn spezifische Punkte vorhanden sind, Zufälligen Punkt in einem Gebäude auswählen
            _spawnPos = selectRandom (call compile format ["%1", life_spawn_point select 0]);
            _spawnPos = _spawnPos buildingPos 0;
            player setPos _spawnPos;
        };
    } else {
        // Wenn es sich nicht um einen Zivilisten handelt, Spieler an festgelegten Punkt setzen
        player setPos (getMarkerPos (life_spawn_point select 0));
    };

    // Erfolgsmeldung anzeigen
    titleText[format ["%2 %1", life_spawn_point select 1, localize "STR_Spawn_Spawned"], "BLACK IN"];
};

// Wenn dies der erste Spawn ist, Willkommensbenachrichtigung anzeigen
if (life_firstSpawn) then {
    life_firstSpawn = false;
    [] call life_fnc_welcomeNotification;
};

// Spieler-Skins aktualisieren
[] call life_fnc_playerSkins;
