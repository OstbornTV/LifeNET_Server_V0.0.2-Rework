#include "..\..\script_macros.hpp"
/*
File: fn_civMarkers.sqf
Author:

Description:
Add markers for civilians in groups.
*/
private _markers = [];

{
    private _marker = createMarkerlocal [format ["%1_marker", netId _x], getPosATL _x];
    _marker setMarkerColorLocal "Colorcivilian";
    _marker setMarkertypeLocal "Mil_dot";
    _marker setMarkertextLocal format ["%1", _x getVariable ["realname", name _x]];
    _markers pushBack [_marker, _x];
} forEach ((units (group player)) - [player]);

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