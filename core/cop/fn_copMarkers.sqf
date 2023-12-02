#include "..\..\script_macros.hpp"
/*
File: fn_copMarkers.sqf
Author: Bryan "tonic" Boardwine

Description:
Marks cops on the map for other cops.
*/

// Array für die Marker initialisieren
private _markers = [];

// Marker für jeden Cop erstellen
{
    private _marker = createMarkerlocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "Colorblufor"; // Blaue Farbe für Marker
    _marker setMarkertypeLocal "Mil_dot"; // Militärischer Punkt-Markertyp
    _marker setMarkertextLocal format ["%1", _x getVariable ["realname", name _x]]; // Markerbeschriftung mit echtem Namen oder Spielername
    _markers pushBack [_marker, _x]; // Marker und Einheit zum Array hinzufügen
} forEach ((units west) - [player]); // Alle Einheiten der westlichen Fraktion außer dem Spieler selbst

// Aktualisierung der Marker, solange die Karte sichtbar ist
while {visibleMap} do {
    {
        _x params [
            ["_mark", ""], // Marker-Variable
            ["_unit", objNull] // Einheit, der der Marker folgt
        ];
        if !(isNull _unit) then {
            _mark setMarkerPosLocal (getPosATL _unit); // Markerposition aktualisieren
        };
    } forEach _markers;
    uiSleep 0.01; // Kurze Pause für die Leistung
};

// Marker beim Beenden des Skripts löschen
{
    _x params [["_mark", ""]];
    deleteMarkerlocal _mark;
} forEach _markers;
