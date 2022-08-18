
/*
    File: fn_openVendorLBTypeChange.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	refreshes item dropdown for vendor dialog
*/

disableSerialization;
private _display = findDisplay 9600;
private _typeDropdown = _display displayCtrl 9607;
private _itemDropdown = _display displayCtrl 9609;

ctrlShow[9611,false];
ctrlShow[9612,false];
ctrlShow[9613,false];
ctrlShow[9614,false];
ctrlShow[9623,false];
(_display displayCtrl 9611) ctrlSetStructuredText parseText "";
(_display displayCtrl 9623) ctrlSetText "";
lbClear _itemDropdown;

switch (lbCurSel _typeDropdown) do {
    case 0 : {
        ctrlShow[9611,true];
        ctrlShow[9623,true];
        ctrlShow[9613,true];
        ctrlShow[9614,true];
        (_display displayCtrl 9608) ctrlSetText format["%1 %2",["choose"] call cat_trade_fnc_getText,["item"] call cat_trade_fnc_getText];
        private "_items";
        if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
            _items = ("true" configClasses (missionConfigFile >> "VirtualItems"));
        } else {
            _items = life_inv_items;
        };
        {
            private _val = 0;
            if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
                _val = missionNamespace getVariable [format["life_inv_%1",(getText(missionConfigFile >> "VirtualItems" >> (configName _x) >> "variable"))],0];
            } else {
                _val = missionNamespace getVariable [_x,0];
            };
            if (_val > 0) then {
                private ["_name","_var"];
                if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
                    _name = localize (getText(_x >> "displayName"));
                    _var = configName _x;
                } else {
                    _name = [_x] call life_fnc_varToStr;
                    _var = [_x,1] call life_fnc_varHandle;
                };
                _itemDropdown lbAdd format["[%1] - %2",_val,_name];
                _itemDropdown lbSetData [(lbSize _itemDropdown)-1,format["%1;%2;%3",0,1,_var]];
                _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,format ["%1 - %3: %2",_name,_val,(["Amount"] call cat_trade_fnc_getText)]];
                _itemDropdown lbSetValue [(lbSize _itemDropdown)-1,_val];                
                if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
                    private _icon = "";
                    _icon = (getText(_x >> "icon"));                    
                    if (!(_icon isEqualTo "")) then {
                        _itemDropdown lbSetPicture [(lbSize _itemDropdown)-1,_icon];
                    };
                };
            };
        } forEach _items;
        private _cargo = getUnitLoadout player;
        private _primaryCargo = _cargo select 0;
        private _secondaryCargo = _cargo select 1;
        private _handgunCargo = _cargo select 2; 
        private _uniformCargo = _cargo select 3;
        private _vestCargo = _cargo select 4;
        private _backpackCargo = _cargo select 5;
        _items = [];
        _cargo = [];
        {
            if (!(_x isEqualTo [])) then { 
                if ((typeName(_x) == "ARRAY")) then {
                    _cargo pushBack [_x select 0,1];
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
            if (!(_x isEqualTo [])) then {
                _cargo pushBack [(_x select 0),1];
            };
        } forEach [_primaryCargo,_secondaryCargo,_handgunCargo];
        {
            if (isClass (configFile >> "CfgMagazines" >> (_x select 0))) then {
                private _index = [_x select 0,_items,_x select 2] call cat_trade_fnc_index;
                if (_index isEqualTo -1) then {
                    _items pushBack [_x select 0,_x select 1,_x select 2];
                } else {
                    private _item = _items select _index;
                    _items set[_index,[(_item select 0),(_item select 1) + (_x select 1),_x select 2]];
                };
            } else {
                private _index = [_x select 0,_items,-1] call cat_trade_fnc_index;
                if (_index isEqualTo -1) then {
                    _items pushBack [_x select 0,(_x select 1)];
                } else {
                    private _item = _items select _index;
                    _items set[_index,[(_item select 0),(_item select 1) + (_x select 1)]];
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
            if (_section isEqualTo "CfgMagazines") then {
                _itemDropdown lbAdd format["[%2] - (%3) %1",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(_x select 2)];
                _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,format ["%1 - %4: %2 - %5: %3",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(_x select 2),(["amount"] call cat_trade_fnc_getText),(["ammoCount"] call cat_trade_fnc_getText)]];
                _itemDropdown lbSetData [(lbSize _itemDropdown)-1,format ["%1;%2;%3;%4",0,0,(_x select 0),(_x select 2)]];
            } else {
                _itemDropdown lbAdd format["[%2] - %1",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1)];
                _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,format ["%1 - %3: %2",(getText(configFile >> _section >> (_x select 0) >> "displayName")),(_x select 1),(["amount"] call cat_trade_fnc_getText)]];
                _itemDropdown lbSetData [(lbSize _itemDropdown)-1,format ["%1;%2;%3",0,0,(_x select 0)]];
            };
            _itemDropdown lbSetValue [(lbSize _itemDropdown)-1,(_x select 1)];
			private _icon = (getText(configFile >> _section >> (_x select 0) >> "picture"));
            if (!(_icon isEqualTo "")) then {
                _itemDropdown lbSetPicture [(lbSize _itemDropdown)-1,_icon];
            };
        } forEach _items;
        if ((lbSize _itemDropdown) isEqualTo 0) then {
            _itemDropdown lbAdd format[["noItemsOwned"] call cat_trade_fnc_getText];
            _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,""];
            _itemDropdown lbSetData [(lbSize _itemDropdown)-1,""];
        };
    };
    case 1 : {
        ctrlShow[9611,true];
        ctrlShow[9612,true];
        (_display displayCtrl 9608) ctrlSetText format["%1 %2",["choose"] call cat_trade_fnc_getText,["vehicle"] call cat_trade_fnc_getText];
        for "_i" from 0 to (count life_vehicles - 1) do {
            private _veh = life_vehicles select _i;            
            if (!isNull _veh && alive _veh && {_veh isKindOf "LandVehicle" || _veh isKindOf "Ship" || _veh isKindOf "Air"}) then {
                private _vInfo = _veh getVariable ["dbInfo",[]];
                private "_uid";
                if (count _vInfo > 0) then {
                    _uid = _vInfo select 0;
                };
                if (_uid isEqualTo (getPlayerUID player)) then {
                    private _color = "";
                    if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
                        _color = ((getArray(missionConfigFile >> "LifeCfgVehicles" >> (typeOf _veh) >> "textures") select (_veh getVariable "Life_VEH_color")) select 0);
                    } else {
                        _color = [(typeOf _veh),(_veh getVariable "Life_VEH_color")] call life_fnc_vehicleColorStr;
                    };                    
		            if (isNil "_color") then {_color = ""};
                    private _text = format ["(%1)",_color];
                    if (_text == "()") then {
                        _text = "";
                    };

                    private _name = getText(configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName");
                    private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _veh) >> "picture");
                    _itemDropdown lbAdd format ["%1 %3 - [%4: %2m]",_name,round(player distance _veh),_text,["distance"] call cat_trade_fnc_getText];
                    if (_pic != "pictureStaticObject") then {
                        _itemDropdown lbSetPicture [(lbSize _itemDropdown)-1,_pic];
                    };
                    _itemDropdown lbSetData [(lbSize _itemDropdown)-1,format ["%1;%2",1,(netId _veh)]];
                };
            };
        };
        if ((lbSize _itemDropdown) isEqualTo 0) then {
            _itemDropdown lbAdd format[["noVehOwned"] call cat_trade_fnc_getText];
            _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,""];
            _itemDropdown lbSetData [(lbSize _itemDropdown)-1,""];
        };
    };
    case 2 : {
        ctrlShow[9611,true];
        ctrlShow[9612,true];
        (_display displayCtrl 9608) ctrlSetText format["%1 %2",["choose"] call cat_trade_fnc_getText,["house"] call cat_trade_fnc_getText];
        for "_i" from 0 to (count life_vehicles - 1) do {
            _house = life_vehicles select _i;
            if (!isNull _house && alive _house && _house isKindOf "House_F") then {
                private _owner = _house getVariable ["house_owner",[]];
                private "_uid";
                if (count _owner > 0) then {
                    _uid = _owner select 0;
                };
                if (_uid isEqualTo (getPlayerUID player)) then {
                    private _name = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
                    private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "picture");
                    _itemDropdown lbAdd format ["%1 - [%3: %2m]",_name,round(player distance _house),["distance"] call cat_trade_fnc_getText];
                    if (_pic != "pictureStaticObject") then {
                        _itemDropdown lbSetPicture [(lbSize _itemDropdown)-1,_pic];
                    };
                    _itemDropdown lbSetData [(lbSize _itemDropdown)-1,format ["%1;%2",2,(netId _house)]];
                };
            };
        };
        if ((lbSize _itemDropdown) isEqualTo 0) then {
            _itemDropdown lbAdd format[["noHousesOwned"] call cat_trade_fnc_getText];
            _itemDropdown lbSetTooltip [lbSize(_itemDropdown)-1,""];
            _itemDropdown lbSetData [(lbSize _itemDropdown)-1,""];
        };
    };
    default {(_display displayCtrl 9608) ctrlSetText "error";};
};

_itemDropdown lbSetCurSel 0;