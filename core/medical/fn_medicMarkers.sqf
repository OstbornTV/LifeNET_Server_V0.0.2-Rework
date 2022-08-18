#include "..\..\script_macros.hpp"
/*
File: fn_medicMarkers.sqf
Author: Bryan "tonic" Boardwine

Description:
Marks downed players on the map when it's open.
*/
private _deadMarkers = [];
private _medicMarkers = [];

{
    private _marker = createMarkerlocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "Colorindependent";
    _marker setMarkertypeLocal "Mil_dot";
    _marker setMarkertextLocal format ["%1", _x getVariable ["realname", name _x]];
    _medicMarkers pushBack [_marker, _x];
} forEach ((units independent) - [player]);

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

{
    _x params [["_mark", ""]];
    deleteMarkerlocal _mark;
} forEach _medicMarkers;

{
    deleteMarkerlocal _x;
} forEach _deadMarkers;