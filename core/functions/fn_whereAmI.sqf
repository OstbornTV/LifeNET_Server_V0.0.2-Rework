/*
    File: fn_whereAmI.sqf
    Author: Dardo

    Description:
    Gibt den nächsten Ressourcentyp basierend auf der Position des Spielers zurück.

    mine (Mine)
    resource (Ressource)
    nothing (Nichts)
*/

private ["_zonem", "_zone", "_mine", "_zoneSize", "_resource", "_nothing"];

// Konfiguration für Mineralien (Mines)
_resourceCfg = missionConfigFile >> "CfgGather" >> "Minerals";

// Iteriere durch die Mineralien-Konfigurationen
for "_i" from 0 to count(_resourceCfg) - 1 do {
    private ["_curConfig", "_resourceZones"];
    _zonem = "";
    _curConfig = _resourceCfg select _i;
    _resourceZones = getArray(_curConfig >> "zones");
    _zoneSize = getNumber(_curConfig >> "zoneSize");

    // Überprüfe, ob der Spieler in einer Zone ist
    {
        if ((player distance (getMarkerPos _x)) < _zoneSize) exitWith {
            _zonem = _x;
        };
    } forEach _resourceZones;

    // Wenn der Spieler in einer Zone ist, beende die Schleife
    if (_zonem != "") exitWith {};
};

// Wenn der Spieler in einer Mine ist, setze den Rückgabewert auf "mine"
if (_zonem != "") exitWith {
    _mine = "mine";
    _mine;
};

// Konfiguration für Ressourcen
_resourceCfg = missionConfigFile >> "CfgGather" >> "Resources";

// Iteriere durch die Ressourcen-Konfigurationen
for "_i" from 0 to count(_resourceCfg) - 1 do {
    private ["_curConfig", "_resourceZones"];
    _zone = "";
    _curConfig = _resourceCfg select _i;
    _resourceZones = getArray(_curConfig >> "zones");
    _zoneSize = getNumber(_curConfig >> "zoneSize");

    // Überprüfe, ob der Spieler in einer Zone ist
    {
        if ((player distance (getMarkerPos _x)) < _zoneSize) exitWith {
            _zone = _x;
        };
    } forEach _resourceZones;

    // Wenn der Spieler in einer Zone ist, beende die Schleife
    if (_zone != "") exitWith {};
};

// Wenn der Spieler in einer Ressourcenzone ist, setze den Rückgabewert auf "resource"
if (_zone != "") exitWith {
    _resource = "resource";
    _resource;
};

// Wenn der Spieler in keiner Zone ist, setze den Rückgabewert auf "nothing"
if (_zone isEqualTo "") exitWith {
    _nothing = "nothing";
    _nothing;
};
