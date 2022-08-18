/*
    File: fn_delVendor.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Removes item/vehicle/house from vendor
*/
params [
    ["_item","",[""]],
    ["_buyer",objNull,[objNull]],
    ["_price","",[""]],
    ["_amount","",[""]],
    ["_case",-1,[0]],
    ["_itemType",-1,[0]],
    ["_magCount",-1,[0]]
];

private _priceNumber = parseNumber(_price);

hint format[(["startingTrade"] call cat_trade_fnc_getText),name _buyer];

switch(_case) do {
    case 0 : {
        private _amountNumber = parseNumber(_amount);
        if (_itemType isEqualTo 1) then {
            private _infoBool = [false,_item,_amountNumber] call life_fnc_handleInv;
        } else {
            if (isClass(configFile >> "CfgMagazines" >> _item)) then {
                for "_j" from 1 to _amountNumber do {
                    private _magazinesAmmo = magazinesAmmo player;
                    private _count = (count _magazinesAmmo) - 1;
                    private _index = -1;
                    for "_i" from 0 to _count do {
                        private _itemOnIndex = (_magazinesAmmo select _i); 
                        if ((_item in _itemOnIndex) && (_index isEqualTo -1)) then {
                            if (_magCount isEqualTo (_itemOnIndex select 1)) then {
                                _index = _i;
                            };
                        };
                    };
                    if (!(_index isEqualTo -1)) then {
                        _magazinesAmmo deleteAt _index;
                    };
                    { player removeMagazine _x } forEach magazines player;
                    { player addMagazine [(_x select 0),(_x select 1)] } forEach _magazinesAmmo;
                };
            } else {
                for "_i" from 1 to (_amountNumber) do {
                    [_item,false] call life_fnc_handleItem;
                };
            };  
        };
        [_item,_buyer,_case,_amount,_itemType,_magCount,_priceNumber] spawn {
            params [
                ["_item","",[""]],
                ["_buyer",objNull,[objNull]],
                ["_case",-1,[0]],
                ["_amount","",[""]],
                ["_itemType",-1,[0]],
                ["_magCount",-1,[0]],
                ["_priceNumber",-1,[0]]
            ];
            sleep 1;
            [3] call SOCK_fnc_updatePartial;
            cat_trade_aborted = true;
            (findDisplay 46) displayRemoveEventHandler ["KeyDown",cat_trade_esc_eventhandler];
            cat_trade_receiver = objNull;
            if ((getNumber(missionConfigFile >> "Cation_Trade" >> "DebugMode")) isEqualTo 1) then {
                diag_log "------ Trade System: vendor item deleted -------";
                diag_log format ["_item: %1",_item];
                diag_log format ["_case: %1",_case];
                diag_log format ["_amount: %1",_amount];
                diag_log format ["_itemType: %1",_itemType];
                diag_log format ["_magCount: %1",_magCount];
                diag_log "------------------------------------------------";
            };
            [_item,_case,_amount,_itemType,_magCount] remoteExecCall ["cat_trade_fnc_addBuyer",_buyer];
            life_cash = life_cash + _priceNumber;
            [0] call SOCK_fnc_updatePartial;
            hint format[["tradeCompleted"] call cat_trade_fnc_getText];
        };
    };
    case 1 : {
		_item = objectFromNetId _item;
        _item setVariable ["vehicle_info_owners",[],true];
        private _color = _item getVariable ["life_veh_color",-1];
        private _trunk = _item getVariable ["trunk",[[],0]];
        private _pos = getPosATL _item;
        private _data = _item getVariable ["dbInfo",[]];
        private _damage = (getAllHitPointsDamage _item);
        private _fuel = fuel _item;
        private _cargo = [getItemCargo _item,getMagazineCargo _item,getWeaponCargo _item,getBackpackCargo _item];
        private _dir = getDir _item;
        cat_trade_aborted = true;
        (findDisplay 46) displayRemoveEventHandler ["KeyDown",cat_trade_esc_eventhandler];
        cat_trade_receiver = objNull;
        if (getNumber(missionConfigFile >> "Cation_Trade" >> "HeadlessSupport") isEqualTo 0) then {
            [_item,_buyer,_case,_color,_trunk,_pos,_data,_damage,_fuel,_cargo,_dir] remoteExec ["cat_trade_fnc_editServer",2];
        } else {
            if (life_HC_isActive) then {
                [_item,_buyer,_case,_color,_trunk,_pos,_data,_damage,_fuel,_cargo,_dir] remoteExec ["cat_trade_fnc_editServerHC",HC_Life];
            } else {
                [_item,_buyer,_case,_color,_trunk,_pos,_data,_damage,_fuel,_cargo,_dir] remoteExec ["cat_trade_fnc_editServer",2];
            };
        };
        life_cash = life_cash + _priceNumber;
        [0] call SOCK_fnc_updatePartial;
        hint format[["tradeCompleted"] call cat_trade_fnc_getText];
    };
    case 2 : {
		_item = objectFromNetId _item;
        life_vehicles = life_vehicles - [_item];
        private _index = [str(getPosATL _item),life_houses] call TON_fnc_index;
        if !(_index isEqualTo -1) then {
            life_houses deleteAt _index;
        };
        _item setVariable ["locked",true,true];
        {
            _x setVariable ["container_owner",-1];
        } forEach (_item getVariable ["containers",[]]);
        deleteMarkerLocal format ["house_%1",_item getVariable "uid"];
        cat_trade_aborted = true;
        (findDisplay 46) displayRemoveEventHandler ["KeyDown",cat_trade_esc_eventhandler];
        cat_trade_receiver = objNull;
        if (getNumber(missionConfigFile >> "Cation_Trade" >> "HeadlessSupport") isEqualTo 0) then {
            [_item,_buyer,_case] remoteExecCall ["cat_trade_fnc_editServer",2];
        } else {
            if (life_HC_isActive) then {
                [_item,_buyer,_case] remoteExecCall ["cat_trade_fnc_editServerHC",HC_Life];
            } else {
                [_item,_buyer,_case] remoteExecCall ["cat_trade_fnc_editServer",2];
            };
        };
        life_cash = life_cash + _priceNumber;
        [0] call SOCK_fnc_updatePartial;
        hint format[["tradeCompleted"] call cat_trade_fnc_getText];
    };
};