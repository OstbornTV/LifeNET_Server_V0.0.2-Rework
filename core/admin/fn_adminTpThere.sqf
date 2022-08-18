#include "..\..\script_macros.hpp"
/*
	File: fn_adminTpThere.sqf
	Author: ColinM9991
	
	Description:
	Teleport selected player to you.
*/

if (FETCH_CONST(life_adminlevel) < 1) exitWith {closeDialog 0};

private["_target"",_messagelog"];
_target = lbData[2902,lbCurSel (2902)];
_target = call compile format["%1", _target];
if(isNil "_target") exitwith {};
if(_target isEqualTo player) exitWith {hint localize "STR_ANOTF_Error";};

if(_target != vehicle _target) then
{
	player moveInAny (vehicle _target);
	_messagelog = format["ADMIN: Du hast dich zu %1 ins Fahrzeug geportet",_target getVariable["realname",name _target]];
}else
{
    private _pos = getPosATL _target;
    player setPosATL [_pos param [0],_pos param [1],(_pos param [2]) +0.5];
	//player setPosATL (getPosATL _target);
	_messagelog = format["ADMIN: Du hast dich zu %1 geportet",_target getVariable["realname",name _target]];
};