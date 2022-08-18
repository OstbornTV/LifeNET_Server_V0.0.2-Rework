/*
    File: fn_addBuyer.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Adds item/vehicle/house to buyer
*/
params [
    ["_item","",[""]],
    ["_case",-1,[0]],
    ["_amount","",[""]],
    ["_itemType",-1,[0]],
    ["_magCount",-1,[0]],
    ["_buyer",objNull,[objNull]]
];

if (cat_trade_aborted) exitWith {};
switch(_case) do {
    case 0 : {
        private _amountNumber = parseNumber(_amount);
        private _name = "";
        if (_itemType isEqualTo 1) then {
            _infoBool = [true,_item,_amountNumber] call life_fnc_handleInv;
        	if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
				_name = format["%1x %2",_amount,localize getText(missionConfigFile >> "VirtualItems" >> _item >> "displayName")];
            } else {
                private _var = [_item,0] call life_fnc_varHandle;
				_name = format["%1x %2",_amount,[_item] call life_fnc_varToStr];
			};
        } else {
            private _bad = false;
            private _used = false;

            if (isClass(configfile >> "CfgVehicles" >> _item)) then {
                player addBackpack _item;
            } else {
                if ((player canAdd [_item,_amountNumber])) then {
                    for "_i" from 1 to _amountNumber do {
                        player addItem _item;
                    };
                } else {
                    for "_i" from 1 to _amountNumber do {
                        if (isClass(configfile >> "CfgWeapons" >> _item)) then {
                            private _base = [(configfile >> "CfgWeapons" >> _item),true ] call BIS_fnc_returnParents;
                            switch (getNumber(configFile >> "CfgWeapons" >> _item >> "type")) do {
                                case 1: {
                                    player addWeapon _item;
                                };
                                case 2: {
                                    player addWeapon _item;
                                };
                                case 4: {
                                    player addWeapon _item;
                                };
                                default {};
                            };
                            if (("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base)) then {
                                player addVest _item;
                            };
                            if ("Uniform_Base" in _base) then {
                                player addUniform _item;
                            };
                            if (("H_HelmetB" in _base) || ("HelmetBase" in _base)) then {
                                player addHeadgear _item;
                            };
                        };
                        if (isClass(configfile >> "CfgGlasses" >> _item)) then {
                            player addGoggles _item;
                        };
                    };
                };
            };
            private _section = switch (true) do {
				case (isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
				case (isClass(configFile >> "CfgWeapons" >> _item)): {"CfgWeapons"};
				case (isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
				case (isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
				default {"CfgWeapons"};
			};
			_name = format["%1x %2",_amount,(getText(configFile >> _section >> _item >> "displayName"))];
        };
        hint format[(["itemTransfered"] call cat_trade_fnc_getText),_name];
        [3] call SOCK_fnc_updatePartial;
    };
    case 1 : {
        _item = objectFromNetId _item;
        [_item] call life_fnc_clearVehicleAmmo;
        if (!(_item in life_vehicles)) then {
            life_vehicles pushBack _item;
        };
        switch (side _buyer) do {
            case west: {
                [_item,"cop_offroad",true] spawn life_fnc_vehicleAnimate;
            };
            case civilian: {
                if ((life_veh_shop select 2) isEqualTo "civ" && {_className == "B_Heli_Light_01_F"}) then {
                    [_item,"civ_littlebird",true] spawn life_fnc_vehicleAnimate;
                };
            };
            case independent: {
                [_item,"med_offroad",true] spawn life_fnc_vehicleAnimate;
            };
        };
        hint format[(["itemTransfered"] call cat_trade_fnc_getText),getText(configFile >> "CfgVehicles" >> (typeOf _item) >> "displayName")];
        [getPlayerUID player,playerSide,_item,1] remoteExecCall ["TON_fnc_keyManagement",2];
    };
    case 2 : {
        _item = objectFromNetId _item;
        life_vehicles pushBack _item;
        life_houses pushBack [str(getPosATL _item),[]];
        _marker = createMarkerLocal [format ["house_%1",(_item getVariable "uid")],getPosATL _item];
        _marker setMarkerTextLocal getText(configFile >> "CfgVehicles" >> (typeOf _item) >> "displayName");
        _marker setMarkerColorLocal "ColorBlue";
        _marker setMarkerTypeLocal "loc_Lighthouse";
        hint format[(["itemTransfered"] call cat_trade_fnc_getText),getText(configFile >> "CfgVehicles" >> (typeOf _item) >> "displayName")];
    };
};