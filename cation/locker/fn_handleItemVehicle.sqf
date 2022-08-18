/*
    File: fn_handleItemVehicle.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Takes items from vehicle / stores items in vehicle.
*/
params[
    ["_item","",[""]],
    ["_add",false,[false]],
    ["_type",-1,[0]],
    ["_index",-1,[0]],
    ["_amount",0,[0]],
    ["_ammoCount",0,[0]]
];

if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};

private _exit = false;
if (((findDisplay 5000) getVariable ["mode",0]) isEqualTo 1) then {
    if ((player distance cat_locker_vehicle) > getNumber(missionConfigFile >> "Cation_Locker" >> "distanceVehicle")) then {
        hint format [["DistanceVehicle"] call cat_locker_fnc_getText,getNumber(missionConfigFile >> "Cation_Locker" >> "distanceVehicle")];
        _exit = true;
    };
};
if (_exit) exitwith {[0] call cat_locker_fnc_switchDisplayMode;};

private _trunkData = cat_locker_vehicle getVariable ["Trunk",[[],0]];
private _inv = _trunkData select 0;

private _weight = _amount * ([_item,_type] call cat_locker_fnc_itemWeight);
private _index = [_item,_inv,-1,-1] call cat_locker_fnc_index;
if (_add) then {
    if (_index isEqualTo -1) then {
        _inv pushBack [_item,_amount];
    } else {
        _inv set[_index,[_item,((_inv select _index select 1) + _amount)]];
    };
    cat_locker_vehicle setVariable["Trunk",[_inv,(_trunkData select 1) + _weight],true];
} else {
    private _value = (_inv select _index) select 1;
    if (_amount isEqualTo _value) then {
        _inv deleteAt _index;
    } else {
        _inv set[_index,[_item,(_value - _amount)]];
    };
    cat_locker_vehicle setVariable["Trunk",[_inv,(_trunkData select 1) - _weight],true];
};

[] call cat_locker_fnc_refreshDialog;