/*
    File: fn_editServerHC.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Updates vehicle/house in database
*/
if (!(!hasInterface && !isDedicated)) exitWith {};
params [
    ["_item",objNull,[objNull]],
    ["_buyer",objNull,[objNull]],
    ["_case",-1,[0]],
    ["_color",-1,[0]],
    ["_trunk",[[],0],[[]]],
    ["_pos",[],[[]]],
    ["_data",[],[[]]],
    ["_damage",[],[[]]],
    ["_fuel",-1,[0]],
    ["_cargo",[],[[]]],
    ["_dir",-1,[0]]
];

private _buyerUID = getPlayerUID _buyer;

if (_case isEqualTo 1) then {
    private _uid = _data select 0;
    private _plate = _data select 1;
    private _class = typeOf _item;
    deleteVehicle _item;    
    waitUntil{isNull _item};
    _item = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
    waitUntil {!isNil "_item" && {!isNull _item}};
    _item allowDamage false;
    _item setDir _dir;
    _item lock 2;
    _item disableTIEquipment true;
    _item setVariable ["trunk_in_use",false,true];
    private _classNameLife = _class;
    if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _classNameLife)) then {
        _classNameLife = "Default";
        diag_log format ["%1: LifeCfgVehicles class doesn't exist",_class];
    };
    if (!(_color isEqualTo -1)) then {
        private _textures = ((getArray(missionConfigFile >> "LifeCfgVehicles" >> _classNameLife >> "textures") select _color) select 2);
        {_item setObjectTextureGlobal [_forEachIndex,_x];} forEach _textures;
        _item setVariable ["Life_VEH_color",_color,true];
    } else {
        _item setVariable ["Life_VEH_color",0,true];
    };
    _item setVariable ["trunk",_trunk,true];
    _item setVariable ["dbInfo",[_buyerUID,_plate],true];
    _item setVariable ["vehicle_info_owners",[[_buyerUID,name _buyer]],true];  
    if !(_damage isEqualTo []) then {
        private _parts = getAllHitPointsDamage _item;
        _damage = _damage select 2;
        for "_i" from 0 to ((count _damage) - 1) do {
            _item setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
        };
    };
    _item setFuel _fuel;
    clearItemCargoGlobal _item;
    clearMagazineCargoGlobal _item;
    clearWeaponCargoGlobal _item;
    clearBackpackCargoGlobal _item;
    private _items = _cargo select 0;
    private _mags = _cargo select 1;
    private _weapons = _cargo select 2;
    private _backpacks = _cargo select 3;

    for "_i" from 0 to ((count (_items select 0)) - 1) do {
        _item addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
    };
    for "_i" from 0 to ((count (_mags select 0)) - 1) do {
        _item addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
    };
    for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
        _item addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
    };
    for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
        _item addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
    };
    _item allowDamage true;
    private _query = format ["UPDATE vehicles SET pid='%1' WHERE pid='%2' AND plate='%3' AND classname='%4'",_buyerUID,_uid,_plate,_classNameLife];
    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
        diag_log "------------- Update Vehicle PID----------------";
        diag_log format ["QUERY: %1",_query];
        diag_log "------------------------------------------------";
    };
    [_query,1] call HC_fnc_asyncCall;

    _data = [_buyerUID,_data select 1];
    _item setVariable ["dbInfo",_data,true];
} else {
    private _id = _item getVariable ["house_id",-1];
    private _uid = _item getVariable ["house_owner",[]] select 0;
    private _query = format ["UPDATE houses SET pid='%1' WHERE pid='%2' AND id='%3'",_buyerUID,_uid,_id];
    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
        diag_log "------------- Update House PID------------------";
        diag_log format ["QUERY: %1",_query];
        diag_log "------------------------------------------------";
    };
    [_query,1] call HC_fnc_asyncCall;    
    _item setVariable ["house_owner",[_buyerUID,name _buyer],true];
    {
        _id = _x getVariable ["container_id",-1];
        _query = format ["UPDATE containers SET pid='%1' WHERE pid='%2' AND id='%3'",_buyerUID,_uid,_id];
        if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
            diag_log "------------- Update Container PID--------------";
            diag_log format ["QUERY: %1",_query];
            diag_log "------------------------------------------------";
        };
        [_query,1] call HC_fnc_asyncCall;    
        _x setVariable ["container_owner",_buyerUID];
    } forEach (_item getVariable ["containers",[]]);
    [_item] remoteExecCall ["cat_trade_fnc_removeFromKeyChain",0];
    _numOfDoors = getNumber(configFile >> "CfgVehicles" >> (typeOf _item) >> "numberOfDoors");
    for "_i" from 1 to _numOfDoors do {
        _item setVariable [format ["bis_disabled_Door_%1",_i],1,true];
    };
};

_item = netId _item;
[_item,_case,"",-1,-1,_buyer] remoteExecCall ["cat_trade_fnc_addBuyer",owner _buyer];