#define ctrlSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
/*
    File: fn_vehicleSelected.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Changes player inventory to selected vehicle inventory
*/
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
disableSerialization;

if ((lbCurSel 5006) isEqualTo -1) exitWith {hint format[["NoSelection"] call cat_locker_fnc_getText]; [] call cat_locker_fnc_refreshDialog;};
private _display = findDisplay 5000;
private _type = _display getVariable ["type",-1];
private _viewMode = _display getVariable ["mode",-1];
if !(_viewMode isEqualTo 2) exitWith {[] call cat_locker_fnc_refreshDialog;};
private _vehicle = ctrlSelData(5006);

cat_locker_vehicle = (objectFromNetId _vehicle);

if ((cat_locker_vehicle getVariable ["trunk_in_use",false])) exitWith { 
    hint localize "STR_MISC_VehInvUse";
    cat_locker_vehicle = objNull;
    _display setVariable ["mode",2];
    [] call cat_locker_fnc_refreshDialog;
};
cat_locker_vehicle setVariable["trunk_in_use",true,true];
cat_locker_vehicle setVariable["trunk_in_use_by",player,true];

_display setVariable ["mode",1];

cat_locker_vehicle spawn {
    private _display = findDisplay 5000;
    waitUntil {(isNull (findDisplay 5000)) || ((_display getVariable ["mode",-1]) isEqualTo 0)};
    _this setVariable ["trunk_in_use",false,true];
};

[] call cat_locker_fnc_refreshDialog;