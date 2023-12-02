#include "..\..\script_macros.hpp"

/*
    File: fn_doorAnimate.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Animates a door
*/

params [
    ["_doorObject", objNull, [objNull]] // Parameter umbenannt für bessere Lesbarkeit
];

// Anzahl der Türen abrufen
private _doors = getNumber (configFile >> "CfgVehicles" >> (typeOf _doorObject) >> "NumberOfDoors");
private _targetDoor = 0;

//-- Finde die nächstgelegene Tür
for "_i" from 1 to _doors do {
    _selPos = _doorObject selectionPosition format ["Door_%1_trigger",_i];
    _worldSpace = _doorObject modelToWorld _selPos;
    if (player distance _worldSpace < 5) exitWith {_targetDoor = _i};
};

//-- Wenn keine Tür in der Nähe ist, zeige eine Meldung und beende das Skript
if (_targetDoor isEqualTo 0) exitWith {hint localize "STR_Cop_NotaDoor"};

//-- Wenn die Tür bereits geöffnet ist, setze das Ziel auf 0 (schließen)
private _target = [1, 0] select (
    ((_doorObject animationPhase format ["door_%1a_move", _targetDoor]) isEqualTo 1) || 
    ((_doorObject animationPhase format ["door_%1_rot", _targetDoor]) isEqualTo 1) || 
    ((_doorObject animationPhase format ["door_%1a_rot", _targetDoor]) isEqualTo 1) 
);

//-- Animation für alle bekannten Quellen abspielen
{
    _doorObject animateSource [format [_x, _targetDoor], _target];
} forEach ["Door_%1_source", "Door_%1_sound_source", "Door_%1_noSound_source"];

closeDialog 0; // Dialog schließen
