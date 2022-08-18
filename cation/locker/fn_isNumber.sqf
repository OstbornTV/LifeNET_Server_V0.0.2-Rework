/*
    File: fn_isNumber.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Checks if given value is a number.
    Code copied from life_server/functions.sqf of the ArmA Life Framework
*/
private ["_valid","_array"];
_valid = ["0","1","2","3","4","5","6","7","8","9"];
_array = [_this select 0] call cat_locker_fnc_StrToArray;
_return = true;
{
    if (!(_x in _valid)) exitWith {
        _return = false;
    };
} forEach _array;
_return;