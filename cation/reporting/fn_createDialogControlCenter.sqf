/*
    File: fn_createDialogControlCenter.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Creates dialog of control center.
*/
if (playerSide isEqualTo west) then {
    if ((call life_coplevel) < (getNumber(missionConfigFile >> "Cation_Reporting" >> "controlCenterMinLevelIndependent"))) exitWith {};
};
if (playerSide isEqualTo independent) then {
    if ((call life_mediclevel) < (getNumber(missionConfigFile >> "Cation_Reporting" >> "controlCenterMinLevelIndependent"))) exitWith {};
};
if (!(playerSide in [west,independent])) exitWith {};
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;}; //If null / dead exit menu
if ((getNumber(missionConfigFile >> "Cation_Reporting" >> "version")) > 3) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
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
if (!createDialog "Cat_reporting_tablet") exitWith {};
disableSerialization;

private _display = findDisplay 9800;
private _statusBox = (_display displayCtrl 9802);
lbClear _statusBox;
(_display displayCtrl 9803) ctrlSetText "";
(_display displayCtrl 9804) ctrlSetText "";
(_display displayCtrl 9805) ctrlSetText format[["titleTablet"] call cat_reporting_fnc_getText];
(_display displayCtrl 9806) ctrlSetText format[["statusPlayer"] call cat_reporting_fnc_getText];
(_display displayCtrl 9807) ctrlSetText format[["playerHeader"] call cat_reporting_fnc_getText];
private _playerListBox = (_display displayCtrl 9808);
lbClear _playerListBox;
(_display displayCtrl 9809) ctrlSetText format[["changeTo"] call cat_reporting_fnc_getText];
(_display displayCtrl 9810) ctrlSetText format[(["ok"] call cat_reporting_fnc_getText)];
(_display displayCtrl 9811) ctrlSetText format[["centerStatus"] call cat_reporting_fnc_getText];
cat_reporting_current_entries = [];
switch (playerSide) do {
    case west: { { if ((side _x isEqualTo west) && (alive _x)) then {cat_reporting_current_entries pushBack _x;};} forEach playableUnits; };
    case independent: { {if ((side _x isEqualTo independent) && (alive _x)) then {cat_reporting_current_entries pushBack _x;};} forEach playableUnits; };
    default { };
};

{
    private _entryStatus = _x getVariable ["reportStatus",2];
    _playerListBox lbAdd format["[%1] %2",_entryStatus,(name _x)];
    _entryStatus = parseNumber(_entryStatus);
    _playerListBox lbSetTooltip [lbSize(_playerListBox)-1,([(_statusArray select _entryStatus) select 1] call cat_reporting_fnc_getText)];
} forEach cat_reporting_current_entries;

{
    _statusBox lbAdd format ["%1 - %2",_x select 0,([_x select 1] call cat_reporting_fnc_getText)];
} forEach _centerStatusArray;
_playerListBox lbSetCurSel 0;

[] spawn cat_reporting_fnc_markers;