#include "..\..\script_macros.hpp"
/*
    File: fn_vehicleAnimate.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Pass what you want to be animated. !!TODO
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_animate", "", ["", []]],
    ["_preset", false, [true]]
];

if (isNull _vehicle) exitWith {};

if (!_preset) then {
    // Benutzen Sie forEach für eine einfachere Iteration
    {
        _vehicle animate [_x select 0, _x select 1];
    } forEach _animate;
} else {
    // Verwenden Sie switch und case für mehr Lesbarkeit
    switch (_animate) do {
        case "civ_littlebird": {
            _vehicle animate ["addDoors", 1];
            _vehicle animate ["addBenches", 0];
            _vehicle animate ["addTread", 0];
            _vehicle animate ["AddCivilian_hide", 1];
            _vehicle lockCargo [2, true];
            _vehicle lockCargo [3, true];
            _vehicle lockCargo [4, true];
            _vehicle lockCargo [5, true];
        };

        case "service_truck": {
            _vehicle animate ["HideServices", 0];
            _vehicle animate ["HideDoor3", 1];
        };

        case "med_offroad": {
            _vehicle animate ["HidePolice", 0];
            _vehicle setVariable ["lights", false, true];
        };

        case "cop_offroad": {
            _vehicle animate ["HidePolice", 0];
            _vehicle animate ["HideBumper1", 0];
            _vehicle setVariable ["lights", false, true];
        };
    };
};
