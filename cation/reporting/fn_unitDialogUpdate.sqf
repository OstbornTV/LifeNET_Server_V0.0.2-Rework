/*
    File: fn_unitDialogUpdate.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Updates dialog of unit.
*/
if (!dialog) exitWith {};
disableSerialization;
params [
    ["_number",""]
];

private _display = findDisplay 9700;
private _statusArray = switch (playerSide) do {
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentVehicle");};
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestVehicle");};
	default {[];};
};
if (_statusArray isEqualTo []) exitWith {};
private _onlyTextStatusArray = [];
{
    _onlyTextStatusArray pushBack (_x select 1);
} forEach _statusArray;
private _onlyStatusArray = [];
{
    _onlyStatusArray pushBack (_x select 0);
} forEach _statusArray;
private _reportStatus = _onlyStatusArray find _number;

_display setVariable ["number",_number];
(_display displayCtrl 9720) ctrlSetText _number;
if (_reportStatus > -1) then {
    (_display displayCtrl 9720) ctrlSetTooltip format[[_onlyTextStatusArray select _reportStatus] call cat_reporting_fnc_getText];
};