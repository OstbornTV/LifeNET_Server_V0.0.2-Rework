/*
    File: fn_lbChanged.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Changes info for selected unit.
*/
disableSerialization;
params [
    ["_control",controlNull,[controlNull]],
    ["_selection",0,[0]]
];
if (!dialog) exitWith {};
private _display = findDisplay 9800;
private _unit = cat_reporting_current_entries select _selection;
private _statusArray = switch (playerSide) do {
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestVehicle");};
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentVehicle");};
	default {[];};
};
if (_statusArray isEqualTo []) exitWith {};
private _centerStatusArray = switch (playerSide) do {
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestCenter");};
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentCenter");};
	default {[];};
};
if (_centerStatusArray isEqualTo []) exitWith {};
private _status = -1;
{
    if ((_unit getVariable "reportCenter") in _x) then {
        _status = _forEachIndex;
    };
} forEach _centerStatusArray;

[(_display displayCtrl 9801),1,0.1,(getPos _unit)] call cat_reporting_fnc_setMapPosition;
(_display displayCtrl 9803) ctrlSetText format["%1",(_unit getVariable "reportCenter")];
if (_status > -1) then {
    (_display displayCtrl 9803) ctrlSetTooltip format["%1",[(_centerStatusArray select _status) select 1] call cat_reporting_fnc_getText];
};
(_display displayCtrl 9804) ctrlSetText format["%1",(_unit getVariable "reportStatus")];
(_display displayCtrl 9804) ctrlSetTooltip format["%1",[(_statusArray select (parseNumber(_unit getVariable "reportStatus"))) select 1] call cat_reporting_fnc_getText];