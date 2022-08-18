/*
    File: fn_statusChanged.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Changes status of unit.
*/
private _display = findDisplay 9700;
private _number = _display getVariable ["number",""];

if (_number isEqualTo "") exitWith {
	hint (["noStatusSelected"] call cat_reporting_fnc_getText);
};

player setVariable ["reportStatus",_number,true];
_display setVariable ["number",""];
(_display displayCtrl 9718) ctrlSetText _number;
(_display displayCtrl 9720) ctrlSetText "";
hint format ["%1: %2",["statusChangedTo"] call cat_reporting_fnc_getText,_number];