#include "..\..\script_macros.hpp"
/*
File: fn_copMarkers.sqf
Author: Bryan "tonic" Boardwine

Description:
Marks cops on the map for other cops.
*/
private _markers = [];

{
    private _marker = createMarkerlocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "Colorblufor";
    _marker setMarkertypeLocal "Mil_dot";
    _marker setMarkertextLocal format ["%1", _x getVariable ["realname", name _x]];
    _markers pushBack [_marker, _x];
} forEach ((units west) - [player]);

while {visibleMap} do {
    {
        _x params [
            ["_mark", ""],
            ["_unit", objNull]
        ];
        if !(isNull _unit) then {
            _mark setMarkerPosLocal (getPosATL _unit);
        };
    } forEach _markers;
    uiSleep 0.01;
};

{
    _x params [["_mark", ""]];
    deleteMarkerlocal _mark;
} forEach _markers;