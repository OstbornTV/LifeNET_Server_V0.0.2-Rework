#include "..\..\script_macros.hpp"
/*
    File: fn_spawnPointCfg.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master configuration for available spawn points depending on the unit's side.

    Return:
    [Spawn Marker, Spawn Name, Image Path]
*/

// Parameter für die Seitenkonfiguration
params [["_side", civilian, [civilian]]];

// Übersetzung der Seitenkennung in eine Klasse (z. B. "west" wird zu "Cop")
_side = switch (_side) do {
    case west: {"Cop"};
    case independent: {"Medic"};
    default {"Civilian"};
};

// Rückgabewert
private _return = [];

// Konfiguration der Spawnpunkte für die Seite abrufen
private _spawnCfg = missionConfigFile >> "CfgSpawnPoints" >> worldName >> _side;

// Durchlaufe die Konfiguration der Spawnpunkte
for "_i" from 0 to count(_spawnCfg) - 1 do {

    // Temporäre Konfigurationsliste für den aktuellen Spawnpunkt
    private _tempConfig = [];
    // Aktuelle Spawnpunkt-Konfiguration
    private _curConfig = _spawnCfg select _i;
    // Bedingungen für den Spawnpunkt
    private _conditions = getText(_curConfig >> "conditions");

    // Überprüfen, ob die Bedingungen erfüllt sind
    private _flag = [_conditions] call life_fnc_levelCheck;

    // Wenn die Bedingungen erfüllt sind, Spawnpunkt zur Rückgabeliste hinzufügen
    if (_flag) then {
        _tempConfig pushBack getText(_curConfig >> "spawnMarker");
        _tempConfig pushBack getText(_curConfig >> "displayName");
        _tempConfig pushBack getText(_curConfig >> "icon");
        _return pushBack _tempConfig;
    };
};

// Wenn die Seite "civilian" ist, füge zusätzliche Häuser als Spawnpunkte hinzu
if (playerSide isEqualTo civilian) then {
    if (count life_houses > 0) then {
        {
            // Position des Hauses
            _pos = call compile format ["%1", (_x select 0)];
            // Nächstes Hausobjekt
            _house = nearestObject [_pos, "House"];
            // Name des Hauses aus der Konfiguration abrufen
            _houseName = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
            // Spawnpunkt als "house_UID" hinzufügen
            _return pushBack [format ["house_%1", _house getVariable "uid"], _houseName, "\a3\ui_f\data\map\MapControl\lighthouse_ca.paa"];

            true
        } count life_houses;
    };
};

// Rückgabewert
_return;
