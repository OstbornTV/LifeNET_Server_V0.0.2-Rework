#include "..\..\script_macros.hpp"
/*
    File: fn_civMarkers.sqf
    Author:

    Description:
    Fügt Markierungen für Zivilisten in Gruppen hinzu.
*/

// Array zum Speichern von Markern und zugehörigen Einheiten
private _markers = [];

{
    // Erstellt einen Marker für jede Zivilisteneinheit in der Gruppe des Spielers
    private _marker = createMarkerLocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "ColorCivilian";
    _marker setMarkerTypeLocal "mil_dot";
    _marker setMarkerTextLocal format ["%1", _x getVariable ["realname", name _x]];
    // Speichert den Marker und die zugehörige Einheit im Array
    _markers pushBack [_marker, _x];
} forEach ((units (group player)) - [player]);

// Aktualisiert die Markerpositionen auf der Karte, solange die Karte sichtbar ist
while {visibleMap} do {
    {
        _x params [
            ["_mark", ""], // Marker-Variable
            ["_unit", objNull] // Einheitsvariable
        ];
        // Überprüft, ob die Einheit nicht null ist, und aktualisiert die Markerposition
        if !(isNull _unit) then {
            _mark setMarkerPosLocal (getPosATL _unit);
        };
    } forEach _markers;
    uiSleep 0.01; // Kurze Verzögerung für die Aktualisierung
};

// Löscht alle erstellten Marker, wenn die Karte nicht mehr sichtbar ist
{
    _x params [["_mark", ""]];
    deleteMarkerLocal _mark;
} forEach _markers;
