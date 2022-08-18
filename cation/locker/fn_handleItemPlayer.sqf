/*
    File: fn_handleItemPlayer.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Main gear handling functionality.
*/
params[
    ["_item","",[""]],
    ["_add",false,[false]],
    ["_amount",1,[1]],
    ["_ammoCount",0,[0]]
];

if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};

if (_item isEqualTo "") exitWith {};
_details = [_item] call life_fnc_fetchCfgDetails;
if (count _details isEqualTo 0) exitWith {};

for "_i" from 1 to _amount do {
    private _isgun = false;

    if (_add) then {
        switch (_details select 6) do {
            case "CfgGlasses": {
                if (goggles player isEqualTo "") then {
                    player addGoggles _item;
                } else {
                    player addItem _item;
                };                
            };

            case "CfgVehicles": {
                player addBackpack _item;
            };

            case "CfgMagazines": {
                player addMagazine [_item,_ammoCount];
            };

            case "CfgWeapons": {

                if ((_details select 4) in [1,2,4,5,4096]) then {
                    if ((_details select 4) isEqualTo 4096) then {
                        if ((_details select 5) isEqualTo -1) then {
                            _isgun = true;
                        };
                    } else {
                        _isgun = true;
                    };
                };

                if (_isgun) then {
                    if (_item isEqualTo "MineDetector") then {
                        player addItem _item;
                    } else {
                        player addWeapon _item;
                    };
                } else {
                    switch (_details select 5) do {
                        case 605: {
                            if (headgear player isEqualTo "") then {
                                player addHeadGear _item;
                            } else {
                                player addItem _item;
                            };
                        };

                        case 801: {
                            if (uniform player isEqualTo "") then {
                                player addUniform _item;
                            } else {
                                player addItem _item;
                            };
                        };

                        case 701: {
                            if (vest player isEqualTo "") then {
                                player addVest _item;
                            } else {
                                player addItem _item;
                            };
                        };

                        default {
                            player addItem _item;
                        };
                    };
                };
            };
        };
    } else {
        switch (_details select 6) do {
            case "CfgVehicles": {
                removeBackpack player;
            };

            case "CfgMagazines": {
                private _magazinesAmmo = magazinesAmmo player;
                private _count = (count _magazinesAmmo) - 1;
                private _index = -1;
                for "_i" from 0 to _count do {
                    private _itemOnIndex = (_magazinesAmmo select _i); 
                    if ((_item in _itemOnIndex) && (_index isEqualTo -1)) then {
                        if (_ammoCount isEqualTo (_itemOnIndex select 1)) then {
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

            case "CfgGlasses": {
                if (_item isEqualTo goggles player) then {
                    removeGoggles player;
                } else {
                    player removeItem _item;
                };
            };

            case "CfgWeapons": {
                if ((_details select 4) in [1,2,4,5,4096]) then {
                    if ((_details select 4) isEqualTo 4096) then {
                        if ((_details select 5) isEqualTo 1) then {
                            _isgun = true;
                        };
                    } else {
                        _isgun = true;
                    };
                };

                if (_isgun) then {
                    private _ispack = true;
                    switch (true) do {
                        case (primaryWeapon player isEqualTo _item) : {_ispack = false;};
                        case (secondaryWeapon player isEqualTo _item) : {_ispack = false;};
                        case (handgunWeapon player isEqualTo _item) : {_ispack = false;};
                        case (_item in assignedItems player) : {_ispack = false;};
                    };

                    if (_item isEqualTo "MineDetector") then {
                        player removeItem _item;
                    } else {

                        //Lovely code provided by [OCB]Dash
                        private "_tmpfunction";
                        _tmpfunction = {
                            private ["_tWeapons","_tWeaponCount"];
                            switch (true) do {
                                case (_this in (uniformItems player)): {
                                    _tWeapons = (getWeaponCargo (uniformContainer player)) select 0;
                                    _tWeaponCount = (getWeaponCargo (uniformContainer  player)) select 1;

                                    clearWeaponCargoGlobal (uniformContainer player);
                                    {
                                        _numVestWeps = _tWeaponCount select _forEachIndex;
                                        if (_x == _this) then
                                        {
                                            _numVestWeps = _numVestWeps - 1;
                                        };
                                        (uniformContainer player) addWeaponCargo [ _x,_numVestWeps];
                                    }forEach _tWeapons;
                                };

                                case (_this in (vestItems player)): {
                                    _tWeapons = (getWeaponCargo (vestContainer player)) select 0;
                                    _tWeaponCount = (getWeaponCargo (vestContainer  player)) select 1;

                                    clearWeaponCargoGlobal (vestContainer player);
                                    {
                                        _numVestWeps = _tWeaponCount select _forEachIndex;
                                        if (_x == _this) then
                                        {
                                            _numVestWeps = _numVestWeps - 1;
                                        };
                                        (vestContainer player) addWeaponCargo [ _x,_numVestWeps];
                                    }forEach _tWeapons;
                                };

                                case (_this in (backpackItems player)): {
                                    _tWeapons = (getWeaponCargo (backpackContainer player)) select 0;
                                    _tWeaponCount = (getWeaponCargo (backpackContainer  player)) select 1;

                                    clearWeaponCargoGlobal (backpackContainer player);
                                    {
                                        _numVestWeps = _tWeaponCount select _forEachIndex;
                                        if (_x == _this) then
                                        {
                                            _numVestWeps = _numVestWeps - 1;
                                        };
                                        (backpackContainer player) addWeaponCargo [ _x,_numVestWeps];
                                    }forEach _tWeapons;
                                };
                            };
                        };

                        if (_ispack) then {
                            _item call _tmpfunction;
                        } else {
                            switch (true) do {
                                case (_item in (uniformItems player)): {_item call _tmpfunction;};
                                case (_item in (vestItems player)) : {_item call _tmpfunction;};
                                case (_item in (backpackItems player)) : {_item call _tmpfunction;};
                                default {player removeWeapon _item;};
                            };
                        };
                    };
                } else {
                    switch (_details select 5) do {
                        case 0: {player unassignItem _item; player removeItem _item;};
                        case 605: {if (headgear player isEqualTo _item) then {removeHeadgear player} else {player removeItem _item};};
                        case 801: {if (uniform player isEqualTo _item) then {removeUniform player} else {player removeItem _item};};
                        case 701: {if (vest player isEqualTo _item) then {removeVest player} else {player removeItem _item};};
                        case 621: {player unassignItem _item; player removeItem _item;};
                        case 616: {player unassignItem _item; player removeItem _item;};
                        default {
                            switch (true) do {
                                case (_item in primaryWeaponItems player) : {player removePrimaryWeaponItem _item;};
                                case (_item in handgunItems player) : {player removeHandgunItem _item;};
                                default {player removeItem _item;};
                            };
                        };
                    };
                };
            };
        };
    };
};
