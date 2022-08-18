/*
    File: fn_refreshDialog.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Used as a refresher for locker inventory.
*/
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
disableSerialization;

if (isNull (findDisplay 5000)) exitWith {};

private _display = findDisplay 5000;
private _lInv = _display displayCtrl 5005;
private _pInv = _display displayCtrl 5006;
lbClear _lInv;
lbClear _pInv;
private _level = cat_locker_level;
private _sizePrice = (getArray(missionConfigFile >> "Cation_Locker" >> "locker_size_price"));

if (_level >= count _sizePrice) then {
    ctrlShow [5012,false];
};

private _type = _display getVariable ["type",0];
private _mode = _display getVariable ["mode",0];
if !(_mode isEqualTo 1) then {
    cat_locker_vehicle = objNull;
} else {
    if (((player distance cat_locker_vehicle) > getNumber(missionConfigFile >> "Cation_Locker" >> "distanceVehicle")) && {!isNull cat_locker_vehicle}) then {
        hint format [["DistanceVehicle"] call cat_locker_fnc_getText,getNumber(missionConfigFile >> "Cation_Locker" >> "distanceVehicle")];
        [0] call cat_locker_fnc_switchDisplayMode;
    };
};

ctrlShow [5026,false];

if (_mode isEqualTo 0) then {
    ctrlShow[5013,true];
    ctrlShow[5014,true];
    ctrlShow[5015,true];
    ctrlShow[5016,true];
    ctrlShow[5017,true];
    ctrlShow[5018,true];
    ctrlShow[5019,true];
    ctrlShow[5020,true];
    private _items = [];
    if !(_type isEqualTo 0) then {
        (_display displayCtrl 5004) ctrlSetText format["%1",["PlayerInventory"] call cat_locker_fnc_getText];
        private _cargo = getUnitLoadout player;
        private _primary = _cargo select 0;
        private _secondary = _cargo select 1;
        private _handgun = _cargo select 2;
        private _uniformCargo = _cargo select 3;
        private _vestCargo = _cargo select 4;
        private _backpackCargo = _cargo select 5;
        _cargo = [];
        {
            if (!(_x isEqualTo [])) then { 
                if ((typeName(_x) == "ARRAY")) then {
                    if ((count (_x select 1) > 0) && _type isEqualTo 3) then {
                        ctrlShow [5026,true];
                        (_display displayCtrl 5026) ctrlSetText format[["WarningClothing"] call cat_locker_fnc_getText];
                    } else {
                        _cargo pushBack [_x select 0,1];
                    };
                    for "_i" from 0 to ((count (_x select 1))-1) do {
                        if ((typeName(((_x select 1) select _i) select 0) == "ARRAY")) then {
                            _cargo pushBack [((((_x select 1) select _i) select 0) select 0),(((_x select 1) select _i) select 1)];
                        } else {
                            _cargo pushBack ((_x select 1) select _i);
                        };
                    };
                };
            };
        } forEach [_uniformCargo,_vestCargo,_backpackCargo];
        {
            if (!((_x) isEqualTo [])) then {
                if ((!((_x select 1) isEqualTo "") || !((_x select 2) isEqualTo "") || !((_x select 2) isEqualTo "") || !((_x select 4) isEqualTo []) || !((_x select 5) isEqualTo []) || !((_x select 6) isEqualTo "")) && _type isEqualTo 1)then {
                    ctrlShow [5026,true];
                    (_display displayCtrl 5026) ctrlSetText format[["WarningWeapon"] call cat_locker_fnc_getText];
                } else {
                    _cargo pushBack [_x select 0,1];
                };
            };
        } forEach [_primary,_secondary,_handgun];
        {
            switch (_type) do {
                case 1 : {
                    if (isClass(configFile >> "CfgWeapons" >> (_x select 0))) then {
                        if (getNumber(configFile >> "CfgWeapons" >> (_x select 0) >> "type") in [1,2,4]) then {
                            private _index = [_x select 0,_items,-1,-1] call cat_locker_fnc_index;
                            if (_index isEqualTo -1) then {
                                _items pushBack [_x select 0,_x select 1];
                            } else {
                                private _item = _items select _index;
                                _items set[_index,[_item select 0,(_item select 1) + (_x select 1)]];
                            };
                        };
                    };
                };
                case 2 : {
                    if (isClass(configFile >> "CfgMagazines" >> (_x select 0))) then {
                        private _index = [_x select 0,_items,2,_x select 2] call cat_locker_fnc_index;
                        if (_index isEqualTo -1) then {
                            _items pushBack [_x select 0,_x select 1,_x select 2];
                        } else {
                            private _item = _items select _index;
                            _items set[_index,[_item select 0,(_item select 1) + (_x select 1),_item select 2]];
                        };
                    };
                    if (isClass(configFile >> "CfgWeapons" >> (_x select 0))) then {
                        _base = [(configfile >> "CfgWeapons" >> (_x select 0)),true] call BIS_fnc_returnParents;
                        if (!(("H_HelmetB" in _base) || ("Uniform_Base" in _base) || ("HelmetBase" in _base) || ("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base))) then {
                            if (("ItemCore" in _base) || ("Binocular" in _base)) then {
                                private _index = [_x select 0,_items,-1,-1] call cat_locker_fnc_index;
                                if (_index isEqualTo -1) then {
                                    _items pushBack [_x select 0,_x select 1];
                                } else {
                                    private _item = _items select _index;
                                    _items set[_index,[_item select 0,(_item select 1) + (_x select 1)]];
                                };
                            };
                        };
                    };
                };
                case 3 : {
                    private _canAdd = false;
                    switch (([_x select 0] call life_fnc_fetchCfgDetails) select 6) do {
                        case "CfgWeapons" : {
                            _base = [(configfile >> "CfgWeapons" >> (_x select 0)),true] call BIS_fnc_returnParents;
                            if (("H_HelmetB" in _base) || ("Uniform_Base" in _base) || ("HelmetBase" in _base) || ("Vest_Camo_Base" in _base) || ("Vest_NoCamo_Base" in _base)) then {
                                _canAdd = true;
                            };
                        };
                        case "CfgGlasses" : { _canAdd = true; };
                        case "CfgVehicles" : { _canAdd = true; };
                    };
                    if (_canAdd) then {
                        private _index = [_x select 0,_items,-1,-1] call cat_locker_fnc_index;
                        if (_index isEqualTo -1) then {
                            _items pushBack [_x select 0,_x select 1];
                        } else {
                            private _item = _items select _index;
                            _items set[_index,[_item select 0,(_item select 1) + (_x select 1)]];
                        };
                    };
                };
            };
        } forEach _cargo;
        {
            private _section = switch (true) do {
                case (isClass(configFile >> "CfgMagazines" >> (_x select 0))): {"CfgMagazines"};
                case (isClass(configFile >> "CfgWeapons" >> (_x select 0))): {"CfgWeapons"};
                case (isClass(configFile >> "CfgVehicles" >> (_x select 0))): {"CfgVehicles"};
                case (isClass(configFile >> "CfgGlasses" >> (_x select 0))): {"CfgGlasses"};
                default {"CfgWeapons"};
            };
            if (!(_section isEqualTo "CfgMagazines")) then {
                _pInv lbAdd format["[%2] - %1",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1)];
                _pInv lbSetTooltip [lbSize(_pInv)-1,format ["%1 - %3: %2",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(["Amount"] call cat_locker_fnc_getText)]];
                _pInv lbSetData [(lbSize _pInv)-1,(_x select 0)];
            } else {
                _pInv lbAdd format["[%2] - (%3) %1",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(_x select 2)];
                _pInv lbSetTooltip [lbSize(_pInv)-1,format ["%1 - %4: %2 - %5: %3",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(_x select 2),(["Amount"] call cat_locker_fnc_getText),(["AmmoCount"] call cat_locker_fnc_getText)]];
                _pInv lbSetData [(lbSize _pInv)-1,format ["%1,%2",(_x select 0),(_x select 2)]];
            };
            _pInv lbSetValue [(lbSize _pInv)-1,(_x select 1)];
			_icon = (getText(configFile >> _section >> (_x select 0) >> "picture"));
            if (!(_icon isEqualTo "")) then {
                _pInv lbSetPicture [(lbSize _pInv)-1,_icon];
            };
        } forEach _items;
    } else {
        (_display displayCtrl 5004) ctrlSetText format["%1 (%2/%3)",["PlayerInventory"] call cat_locker_fnc_getText,life_carryWeight,life_maxWeight];
        if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 3) then {
            _items = ("true" configClasses (missionConfigFile >> "VirtualItems"));
        } else {
            _items = life_inv_items;
        };
        {
            private _val = 0;
            if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 3) then {
                _val = missionNamespace getVariable [format["life_inv_%1",(getText(missionConfigFile >> "VirtualItems" >> (configName _x) >> "variable"))],0];
            } else {
                _val = missionNamespace getVariable [_x,0];
            };
            if (_val > 0) then {
                private _name = "";
                private _icon = "";
                private _var = "";
                if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 3) then {
                    _name = getText(_x >> "displayName");
                    _name = localize _name;
                    _icon = getText(_x >> "icon");
                    _var = configName _x;
                } else {
                    _name = [_x] call life_fnc_varToStr;
                    _var = [_x,1] call life_fnc_varHandle;
                };
                _pInv lbAdd format["[%1] - %2",_val,_name];
                _pInv lbSetData [(lbSize _pInv)-1,_var];
                _pInv lbSetTooltip [lbSize(_pInv)-1,format ["%1 - %3: %2",_name,_val,(["Amount"] call cat_locker_fnc_getText)]];
                if (!(_icon isEqualTo "")) then {
                    _pInv lbSetPicture [(lbSize _pInv)-1,_icon];
                };
                _pInv lbSetValue [(lbSize _pInv)-1,_val];
            };
        } forEach _items;
    };
} else {
    ctrlShow[5013,true];
    ctrlShow[5014,true];
    ctrlShow[5034,true];
    ctrlShow[5015,false];
    ctrlShow[5016,false];
    ctrlShow[5036,false];
    ctrlShow[5017,false];
    ctrlShow[5018,false];
    ctrlShow[5038,false];
    ctrlShow[5019,false];
    ctrlShow[5020,false];
    ctrlShow[5040,false];
    if (_mode isEqualTo 1) then {
        (_display displayCtrl 5004) ctrlSetText format["%1 (%2/%3)",["VehicleInventory"] call cat_locker_fnc_getText,(([cat_locker_vehicle] call life_fnc_vehicleWeight) select 1),(([cat_locker_vehicle] call life_fnc_vehicleWeight) select 0)];
            
        {
            private _val = (_x select 1);
            if (_val > 0) then {
                private _name = "";
                private _icon = "";
                if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 3) then {
                    _name = getText(missionConfigFile >> "VirtualItems" >> (_x select 0) >> "displayName");
                    _name = localize _name;
                    _icon = getText(missionConfigFile >> "VirtualItems" >> (_x select 0) >> "icon");
                } else {
                    _name = [([(_x select 0),0] call life_fnc_varHandle)] call life_fnc_varToStr;
                };
                _pInv lbAdd format["[%1] - %2",_val,_name];
                _pInv lbSetData [(lbSize _pInv)-1,(_x select 0)];
                _pInv lbSetTooltip [lbSize(_pInv)-1,format ["%1 - %3: %2",_name,_val,(["Amount"] call cat_locker_fnc_getText)]];
                if (!(_icon isEqualTo "")) then {
                    _pInv lbSetPicture [(lbSize _pInv)-1,_icon];
                };
                _pInv lbSetValue [(lbSize _pInv)-1,_val];
            };
        } forEach ((cat_locker_vehicle getVariable ["Trunk",[]]) select 0);
    };
};
private _carryWeight = 0;
{
    private _val = (_x select 2);
    _carryWeight = _carryWeight + (([_x select 1,_x select 0] call cat_locker_fnc_itemWeight) * _val);
    switch (_type) do {
        case 0: {
            if ((_x select 0) isEqualTo _type) then {
                if (_val > 0) then {
                    private _name = "";
                    private _icon = "";
                    if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 3) then {
                        _name = getText(missionConfigFile >> "VirtualItems" >> (_x select 1) >> "displayName");
                        _name = localize _name;
                        _icon = getText(missionConfigFile >> "VirtualItems" >> (_x select 1) >> "icon");
                    } else {
                        _name = [([(_x select 1),0] call life_fnc_varHandle)] call life_fnc_varToStr;
                    };
                    _lInv lbAdd format["[%1] - %2",_val,_name];
                    _lInv lbSetData [(lbSize _lInv)-1,(_x select 1)];
                    _lInv lbSetTooltip [lbSize(_lInv)-1,format ["%1 - %3: %2",_name,_val,(["Amount"] call cat_locker_fnc_getText)]];
                    if (!(_icon isEqualTo "")) then {
                        _lInv lbSetPicture [(lbSize _lInv)-1,_icon];
                    };
                    _lInv lbSetValue [(lbSize _lInv)-1,_val];
                };
            };
        };
        default {
            if ((_x select 0) isEqualTo _type) then {
                private _val = (_x select 2);
                if (_val > 0) then {
                    private _section = switch (true) do {
                        case (isClass(configFile >> "CfgMagazines" >> (_x select 1))): {"CfgMagazines"};
                        case (isClass(configFile >> "CfgWeapons" >> (_x select 1))): {"CfgWeapons"};
                        case (isClass(configFile >> "CfgVehicles" >> (_x select 1))): {"CfgVehicles"};
                        case (isClass(configFile >> "CfgGlasses" >> (_x select 1))): {"CfgGlasses"};
                        default {"CfgWeapons"};
                    };
                    private _name = (getText(configFile >> _section >> (_x select 1) >> "displayName"));
                    if (!(_section isEqualTo "CfgMagazines")) then {
                        _lInv lbAdd format["[%1] - %2",_val,_name];
                        _lInv lbSetData [(lbSize _lInv)-1,(_x select 1)];
                        _lInv lbSetTooltip [lbSize(_lInv)-1,format ["%1 - %3: %2",_name,_val,(["Amount"] call cat_locker_fnc_getText)]];
                        _icon = (getText(configFile >> _section >> (_x select 1) >> "picture"));
                        if (!(_icon isEqualTo "")) then {
                            _lInv lbSetPicture [(lbSize _lInv)-1,_icon];
                        };
                        _lInv lbSetValue [(lbSize _lInv)-1,_val];
                    } else {
                        _lInv lbAdd format["[%1] - (%3) %2",_val,_name,(_x select 3)];
                        _lInv lbSetData [(lbSize _lInv)-1,format ["%1,%2",(_x select 1),(_x select 3)]];
                        _lInv lbSetTooltip [lbSize(_lInv)-1,format ["%1 - %4: %2 - %5: %3",_name,_val,(_x select 3),(["Amount"] call cat_locker_fnc_getText),(["AmmoCount"] call cat_locker_fnc_getText)]];
                        _icon = (getText(configFile >> _section >> (_x select 1) >> "picture"));
                        if (!(_icon isEqualTo "")) then {
                            _lInv lbSetPicture [(lbSize _lInv)-1,_icon];
                        };
                        _lInv lbSetValue [(lbSize _lInv)-1,(_x select 3)];
                    };
                };
            };
        };
    };
} forEach cat_locker_trunk;
if (_mode isEqualTo 2) then {
    ctrlEnable[5005,false];
    ctrlEnable[5007,false];
    ctrlEnable[5008,false];
    ctrlShow[5009,false];
    ctrlShow[5010,false];
    ctrlShow[5027,true];
    (_display displayCtrl 5004) ctrlSetText format[["ChooseVehicle"] call cat_locker_fnc_getText];
    (_display displayCtrl 5027) ctrlSetText format[["SelectVehicle"] call cat_locker_fnc_getText];
    {
        if (((player distance _x) <  getNumber(missionConfigFile >> "Cation_Locker" >> "distanceVehicle")) && !(_x isKindOf "House_F")) then {
            _pInv lbAdd getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
            private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "picture");        
            if (_pic != "pictureStaticObject") then {
                _pInv lbSetPicture [(lbSize _pInv)-1,_pic];
            };
            _pInv lbSetData [(lbSize _pInv)-1,(netId _x)];
        };
    } forEach life_vehicles;
} else {
    ctrlEnable[5005,true];
    ctrlEnable[5007,true];
    ctrlEnable[5008,true];
    ctrlShow[5009,true];
    ctrlShow[5010,true];
    ctrlShow[5027,false];
};
if ((lbSize _lInv) isEqualTo 0) then {
    _lInv lbAdd format [["NoItems"] call cat_locker_fnc_getText];
    _lInv lbSetData [(lbSize _lInv)-1,"leer"];
    ctrlEnable[5007,false];
};
if ((lbSize _pInv) isEqualTo 0) then {    
    if (_mode isEqualTo 2) then {
        _pInv lbAdd format [["NoVehicles"] call cat_locker_fnc_getText];
    } else {
        _pInv lbAdd format [["NoItems"] call cat_locker_fnc_getText];
    };
    _pInv lbSetData [(lbSize _pInv)-1,"leer"];
    ctrlEnable[5010,false];
    ctrlEnable[5027,false];
} else {
    ctrlEnable[5010,true];
    ctrlEnable[5027,true];
};
if (_type isEqualTo 1) then {
    ctrlEnable[5008,false];
    (_display displayCtrl 5008) ctrlSetText "1";
} else {
    if (_mode isEqualTo 0) then {
        ctrlEnable[5008,true];
    };
};

cat_locker_carryWeight = _carryWeight;
private _maxWeight = cat_locker_maxWeight;
if (_maxWeight > 0) then {
    ((uiNamespace getVariable ["LockerMenu",displayNull]) displayCtrl 5002) progressSetPosition (_carryWeight / _maxWeight);
};
(_display displayCtrl 5025) ctrlSetText format[(["Weight"] call cat_locker_fnc_getText)+ " %1/%2",_carryWeight,_maxWeight];

locker_in_use = false;