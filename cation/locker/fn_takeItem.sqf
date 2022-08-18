#define ctrlSelData(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
/*
    File: fn_takeItem.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Takes things from locker    
*/
params[["_mode",0,[0]]];
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
disableSerialization;
if (locker_in_use) exitWith { hint format [["NotSoFast"] call cat_locker_fnc_getText];};
locker_in_use = true; 

if ((lbCurSel 5005) isEqualTo -1) exitWith {hint format[["NoSelection"] call cat_locker_fnc_getText]; [] call cat_locker_fnc_refreshDialog;};
private _display = findDisplay 5000;
private _type = _display getVariable ["type",-1];
private _viewMode = _display getVariable ["mode",-1];
if (_viewMode isEqualTo 2) exitWith {
    [] call cat_locker_fnc_vehicleSelected;
};
private _item = ctrlSelData(5005);
private _ammoCount = -1;
if(_type isEqualTo 2) then {
    private _dataArray = _item splitString ",";
    if (count _dataArray isEqualTo 2) then {
        _item = _dataArray select 0;
        _ammoCount = parseNumber (_dataArray select 1);
    };
};
if (_item isEqualTo "leer") exitWith {[] call cat_locker_fnc_refreshDialog;};
if (_item isEqualTo "") exitWith {[] call cat_locker_fnc_refreshDialog;};
private _amount = -1;
private _trunkData = cat_locker_trunk;
private _index = [_item,cat_locker_trunk,3,_ammoCount] call cat_locker_fnc_index;
if (_index isEqualTo -1) exitWith {[] call cat_locker_fnc_refreshDialog;};
private _value = _trunkData select _index select 2;
private _exit = false;

private _storage = 1;
if (_viewMode isEqualTo 1) then {
    _storage = 2;
};
if (_mode isEqualTo 0) then {
    _amount = ctrlText 5008;
    if (!([_amount] call cat_locker_fnc_isNumber)) then { _exit = true; hint format[["WrongNumFormat"] call cat_locker_fnc_getText];};
    _amount = parseNumber(_amount);
    if (_amount > _value) then {_exit = true; hint format[["NotEnoughLocker"] call cat_locker_fnc_getText]};
    if (_amount > [_item,_type,_storage] call cat_locker_fnc_canStore) then {_exit = true; hint format[["InvFull"] call cat_locker_fnc_getText]};
    if (_amount < 1) then { _exit = true; hint format[["Under1"] call cat_locker_fnc_getText];};
} else {
    _amount = [_item,_type,_storage] call cat_locker_fnc_canStore;
    if (_amount > _value) then {
        _amount = _value;
    };
    if (_amount < 1) then { _exit = true; hint format[["InvFull"] call cat_locker_fnc_getText];};
};
if (_exit) exitWith {[] call cat_locker_fnc_refreshDialog;};

if (_type isEqualTo 0) then {
    if (_viewMode isEqualTo 1) then {
        if ((cat_locker_vehicle getVariable ["trunk_in_use_by",player]) != player) exitWith { hint localize "STR_MISC_VehInvUse"; [0] call cat_locker_fnc_switchDisplayMode; };
        [_item,true,_type,_index,_amount,_ammoCount] call cat_locker_fnc_handleItemVehicle;        
        [_item,false,_type,_index,_amount,_ammoCount] call cat_locker_fnc_handleItemLocker;
    } else {
        if ([true,_item,_amount] call life_fnc_handleInv) then {
            [_item,false,_type,_index,_amount,_ammoCount] call cat_locker_fnc_handleItemLocker;
        } else {
            hint format[["InvFull"] call cat_locker_fnc_getText];
            [] call cat_locker_fnc_refreshDialog;
        };
    };
} else {
    [_item,true,_amount,_ammoCount] call cat_locker_fnc_handleItemPlayer;
    [_item,false,_type,_index,_amount,_ammoCount] call cat_locker_fnc_handleItemLocker;
};