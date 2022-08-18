/*
    File: fn_finishStatusChange.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Finishes status change.
*/
private _selection = lbCurSel 9802;
private _unitSelection = lbCurSel 9808;
if (_selection isEqualTo -1 || _unitSelection isEqualTo -1) exitWith {
	hint (["nothingSelected"] call cat_reporting_fnc_getText);
};
private _centerStatusArray = switch (playerSide) do {
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentCenter");};
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestCenter");};
	default {[];};
};
if (_centerStatusArray isEqualTo []) exitWith {};
private _unit = cat_reporting_current_entries select _unitSelection;
private _status = (_centerStatusArray select _selection) select 0;
private _text = [(_centerStatusArray select _selection) select 1] call cat_reporting_fnc_getText;
private _display = findDisplay 9800;
_unit setVariable ["reportCenter",_status,true];
(_display displayCtrl 9803) ctrlSetText format["%1",_status];
(_display displayCtrl 9803) ctrlSetTooltip format["%1",_text];

[_status,_text] remoteExecCall ["cat_reporting_fnc_statusMessage",_unit];