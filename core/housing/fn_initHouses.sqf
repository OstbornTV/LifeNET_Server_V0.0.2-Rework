#include "..\..\script_macros.hpp"
/*
    Datei: fn_initHouses.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Initialisiert die Häuser der Spieler, indem für jedes Haus Marker erstellt werden.

*/

if (life_houses isEqualTo []) exitWith {}; // Falls es keine Häuser gibt, beende das Skript.

{
    // Extrahiere die Position direkt aus dem Array.
    _position = _x select 0;

    // Finde das nächstgelegene Hausobjekt.
    _house = nearestObject [_position, "House"];

    // Setze eine eindeutige Kennung (UID) für das Haus.
    _house setVariable ["uid", floor(random 99999), true];

    // Hole den Anzeigenamen des Hauses aus seiner Konfiguration.
    _houseName = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");

    // Erstelle einen lokalen Marker für das Haus.
    _marker = createMarkerLocal [format ["house_%1", (_house getVariable "uid")], _position];

    // Setze Marker-Eigenschaften.
    _marker setMarkerTextLocal _houseName;
    _marker setMarkerColorLocal "ColorBlue";
    _marker setMarkerTypeLocal "loc_Lighthouse";

} forEach life_houses;
