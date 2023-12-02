#include "..\..\script_macros.hpp"
/*
    File: fn_medicMarkers.sqf
    Author: Bryan "tonic" Boardwine

    Description:
    Marks downed players and medics on the map when it's open.
*/

// Erstellen von Medics-Markern
private _medicMarkers = [];
{
    private _marker = createMarkerlocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "Colorindependent";
    _marker setMarkertypeLocal "Mil_dot";
    _marker setMarkertextLocal format ["%1", _x getVariable ["realname", name _x]];
    _medicMarkers pushBack [_marker, _x];
} forEach ((units independent) - [player]);

// Erstellen von Markern für bewusstlose Spieler
private _deadMarkers = [];
{
    private _name = _x getVariable "name";
    private _down = _x getVariable ["Revive", false];
    if (!isnil "_name" && !_down) then {
        private _marker = createMarkerlocal [format ["%1_dead_marker", netId _x], getPosATL _x];
        _marker setMarkerColorLocal "ColorRed";
        _marker setMarkertypeLocal "loc_Hospital";
        _marker setMarkertextLocal format ["%1", _name];
        _deadMarkers pushBack [_marker, _x];
    };
} forEach allDeadMen;

// Aktualisieren der Marker, solange die Karte sichtbar ist
while {visibleMap} do {
    {
        _x params [
            ["_mark", ""],
            ["_unit", objNull]
        ];
        if !(isNull _unit) then {
            _mark setMarkerPosLocal (getPosATL _unit);
        };
    } forEach (_medicMarkers + _deadMarkers);
    uiSleep 0.01;
};

// Löschen der erstellten Marker, wenn die Karte nicht mehr sichtbar ist
{
    _x params [["_mark", ""]];
    deleteMarkerlocal _mark;
} forEach (_medicMarkers + _deadMarkers);
