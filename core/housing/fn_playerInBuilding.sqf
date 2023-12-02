/*
    File: fn_playerInBuilding.sqf
    Author: Mad_Cheese

    Description:
    Indicates whether a player is in a building.
    Edit: BoGuu - lineIntersectsWith returns an array ordered by distance from farthest to closest.
    Script needed to check the last index for each wallCheck array.

    Parameter(s):
    0: OBJECT - Unit

    Returns:
    BOOL - True if player is in a building, else false

    Example
    //--- Find if a unit is in building
    [player] call life_fnc_playerInBuilding
*/

private ["_unit", "_position", "_eyePosition", "_return", "_roofCheck", "_array"];

_unit = _this select 0;
_position = getPosASL _unit;
_eyePosition = eyePos _unit;
_return = false;
_array = [];

// Definiere Punkte für Dach, Boden und Wände
_roof = [_eyePosition select 0, _eyePosition select 1, (_eyePosition select 2) + 20];
_floor = [_eyePosition select 0, _eyePosition select 1, (_eyePosition select 2) - 5];
_wallFront = [_eyePosition select 0 + 50 * sin(getDir _unit), _eyePosition select 1 + 50 * cos(getDir _unit), (_eyePosition select 2)];
_wallBack = [_eyePosition select 0 + (-50) * sin(getDir _unit), _eyePosition select 1 + (-50) * cos(getDir _unit), (_eyePosition select 2)];
_wallRight = [_eyePosition select 0 + 50 * sin(getDir _unit + 90), _eyePosition select 1 + 0 * cos(getDir _unit), (_eyePosition select 2)];
_wallLeft = [_eyePosition select 0 + (-50) * sin(getDir _unit + 90), _eyePosition select 1 + 0 * cos(getDir _unit), (_eyePosition select 2)];

// Überprüfe, ob die Linien das Dach schneiden
_roofCheck = lineIntersectsWith [_eyePosition, _roof, _unit, _unit, true];

// Falls das Dach nicht getroffen wurde, beende die Ausführung
if (_roofCheck isEqualTo []) exitWith {
    _return
};

// Überprüfe, ob die Linien den Boden und die Wände schneiden
{
    _index = (count _x) - 1;
    if (_index > -1) then {
        if ((_x select _index) isKindOf "House_F") then {
            _array pushBack (_x select _index);
        };
    };
} forEach [_wallFront, _wallBack, _wallRight, _wallLeft, _floorCheck];

// Überprüfe, ob der Spieler in einem Gebäude ist (mindestens 3 Treffer erforderlich)
if ({_x == (_roofCheck select 0)} count _array >= 3) then {
    _return = true;
} else {
    _return = false;
};

_return;
