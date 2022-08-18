/*
    File: fn_createDialogUnit.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Creates dialog of normal unit.
*/
if (!(playerSide in [west,independent])) exitWith {};
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;}; //If null / dead exit menu
if ((getNumber(missionConfigFile >> "Cation_Reporting" >> "version")) > 3) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
if !("ItemRadio" in assignedItems player) exitWith {hint (["noRadio"] call cat_reporting_fnc_getText)};
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
private _reportStatus = _onlyStatusArray find (player getVariable ["reportStatus",""]);
private _statusCenterArray = switch (playerSide) do {
	case independent: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusIndependentCenter");};
	case west: {getArray(missionConfigFile >> "Cation_Reporting" >> "statusWestCenter");};
	default {[];};
};
if (_statusCenterArray isEqualTo []) exitWith {};
private _onlyTextStatusCenterArray = [];
{
    _onlyTextStatusCenterArray pushBack (_x select 1);
} forEach _statusCenterArray;
private _onlyStatusCenterArray = [];
{
    _onlyStatusCenterArray pushBack (_x select 0);
} forEach _statusCenterArray;
private _reportCenterStatus = _onlyStatusCenterArray find (player getVariable ["reportCenter",""]);
if (!createDialog "Cat_reporting_phone") exitWith {};
disableSerialization;

params [
    ["_number",""]
];
private _display = findDisplay 9700;
_display setVariable ["number",_number];
(_display displayCtrl 9701) ctrlSetTooltip format["%1",[(_statusArray select 1) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9702) ctrlSetTooltip format["%1",[(_statusArray select 2) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9703) ctrlSetTooltip format["%1",[(_statusArray select 3) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9704) ctrlSetTooltip format["%1",[(_statusArray select 4) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9705) ctrlSetTooltip format["%1",[(_statusArray select 5) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9706) ctrlSetTooltip format["%1",[(_statusArray select 6) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9707) ctrlSetTooltip format["%1",[(_statusArray select 7) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9708) ctrlSetTooltip format["%1",[(_statusArray select 8) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9709) ctrlSetTooltip format["%1",[(_statusArray select 9) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9710) ctrlSetTooltip format["%1",[(_statusArray select 0) select 1] call cat_reporting_fnc_getText];
(_display displayCtrl 9711) ctrlSetTooltip format[["backTo"] call cat_reporting_fnc_getText];
(_display displayCtrl 9712) ctrlSetTooltip format[["saveStatus"] call cat_reporting_fnc_getText];
(_display displayCtrl 9713) ctrlSetTooltip format[["deleteNumber"] call cat_reporting_fnc_getText];
(_display displayCtrl 9714) ctrlSetStructuredText parseText format["<t align='center'>%1</t>",(["titlePhone"] call cat_reporting_fnc_getText)];
(_display displayCtrl 9715) ctrlSetText format[["changeStatusTo"] call cat_reporting_fnc_getText];
(_display displayCtrl 9716) ctrlSetText format[["centerStatus"] call cat_reporting_fnc_getText];
(_display displayCtrl 9717) ctrlSetText format[["ownStatus"] call cat_reporting_fnc_getText];
(_display displayCtrl 9718) ctrlSetText (player getVariable ["reportStatus",""]);
(_display displayCtrl 9718) ctrlSetTooltip format[[_onlyTextStatusArray select _reportStatus] call cat_reporting_fnc_getText];
(_display displayCtrl 9719) ctrlSetText (player getVariable ["reportCenter",""]);
if (_reportCenterStatus > -1) then {
    (_display displayCtrl 9719) ctrlSetTooltip format[[_onlyTextStatusCenterArray select _reportCenterStatus] call cat_reporting_fnc_getText];
};
(_display displayCtrl 9720) ctrlSetText _number;
(_display displayCtrl 9721) ctrlSetTooltip format[["help"] call cat_reporting_fnc_getText];