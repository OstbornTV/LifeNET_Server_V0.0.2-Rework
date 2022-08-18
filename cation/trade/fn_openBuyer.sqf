/*
    File: fn_openBuyer.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	opens dialog for buyer
*/
private ["_listbox","_checkbox","_color","_text","_name","_pic"];
params [
    ["_item","",[""]],
    ["_vendor",objNull,[objNull]],
    ["_price","",[""]],
    ["_amount","",[""]],
    ["_case",-1,[0]],
    ["_itemType",-1,[0]],
    ["_magCount",-1,[0]]
];
if (isNull _vendor || !alive _vendor || isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {[_vendor,2] call cat_trade_fnc_abort};
if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {[_vendor,2] call cat_trade_fnc_abort};
};
closeDialog 0;
cat_trade_aborted = false;
if (dialog) exitWith {[_vendor,2] call cat_trade_fnc_abort};
if (!createDialog "Cat_trade_buyer") exitWith {[_vendor,2] call cat_trade_fnc_abort};
disableSerialization;

private _display = findDisplay 9600;

cat_trade_vendor = _vendor;
_display displayRemoveAllEventHandlers "KeyDown";
_display displayAddEventHandler ["KeyDown", {
	_keyDown = _this select 1;
    if (_keyDown isEqualTo 1) then {            
        [cat_trade_vendor,2] call cat_trade_fnc_abort;
    };
    true;
}];

(_display displayCtrl 9601) ctrlSetText format[["treaty"] call cat_trade_fnc_getText];
(_display displayCtrl 9602) ctrlSetText format["%1:",["buyer"] call cat_trade_fnc_getText];
(_display displayCtrl 9603) ctrlSetText format["%1",name player];
(_display displayCtrl 9604) ctrlSetText format["%1:",["vendor"] call cat_trade_fnc_getText];
(_display displayCtrl 9605) ctrlSetText format["%1",name _vendor];
(_display displayCtrl 9606) ctrlSetText format["%1",["type"] call cat_trade_fnc_getText];
(_display displayCtrl 9610) ctrlSetText format["%1",["details"] call cat_trade_fnc_getText];
private _details = _display displayCtrl 9611;
private _map = _display displayCtrl 9612;
if (_case isEqualTo 0) then {
	(_display displayCtrl 9613) ctrlSetText format["%1:",["amount"] call cat_trade_fnc_getText];
	(_display displayCtrl 9614) ctrlSetText format["%1",parseNumber(_amount)];
} else {
	ctrlShow[9613,false];
	ctrlShow[9614,false];
};
(_display displayCtrl 9615) ctrlSetText format["%1:",["price"] call cat_trade_fnc_getText];
(_display displayCtrl 9616) ctrlSetText format["%1",_price];
private _checkbox = _display displayCtrl 9617;
(_display displayCtrl 9618) ctrlSetText format[["accept"] call cat_trade_fnc_getText];
(_display displayCtrl 9619) ctrlSetText format["%1, %2.%3.%4",text ((nearestLocations [player,["NameCityCapital","NameCity","NameVillage"],10000]) select 0),date select 2, date select 1, date select 0];
(_display displayCtrl 9620) ctrlSetText format["%1",["sign"] call cat_trade_fnc_getText];
(_display displayCtrl 9621) ctrlSetText format["%1",name _vendor];
(_display displayCtrl 9622) ctrlSetText format["%1",name player];
(_display displayCtrl 9624) ctrlSetText format["%1",name _vendor];

private _marker = createMarkerLocal ["cat_trade_marker",[0,0]];

[] spawn {
    for "_i" from 0 to 1 step 0 do {
        sleep 1;
        if (!dialog) exitWith {
            deleteMarkerLocal "cat_trade_marker";
        };
    };
};

switch (_case) do {
    case 0 : {
		ctrlShow[9612,false];
        (_display displayCtrl 9607) ctrlSetText format[["items"] call cat_trade_fnc_getText];
        (_display displayCtrl 9608) ctrlSetText format[["item"] call cat_trade_fnc_getText];
		if (_itemType isEqualTo 1) then {
			private _illegal = getNumber(missionConfigFile >> "VirtualItems" >> _item >> "illegal");
			private _weight = getNumber(missionConfigFile >> "VirtualItems" >> _item >> "weight");
			(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
				"%2: %1<br/>" +
				"%3",
				_weight,
				["weight"] call cat_trade_fnc_getText,
				if (_illegal isEqualTo 1) then {
					format["<t color='#ff0000'>%1</t>",["illegal"] call cat_trade_fnc_getText]
				} else {
					format["<t color='#008000'>%1</t>",["legal"] call cat_trade_fnc_getText]
				}
			];
			private _name = "";
        	if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
				_name = localize getText(missionConfigFile >> "VirtualItems" >> _item >> "displayName");
				private _icon = "";
                _icon = getText(missionConfigFile >> "VirtualItems" >> _item >> "icon");
				if (!(_icon isEqualTo "")) then {
					(_display displayCtrl 9623) ctrlSetText _icon;
				};
            } else {
                private _var = [_item,0] call life_fnc_varHandle;
				_name = [_item] call life_fnc_varToStr;
			};
			(_display displayCtrl 9609) ctrlSetStructuredText parseText format ["%1",_name];
		} else {
			private _itemInfo = [_item] call life_fnc_fetchCfgDetails;
			private _icon = "";
			_icon = (_itemInfo select 2);
			if (!(_icon isEqualTo "")) then {
				(_display displayCtrl 9623) ctrlSetText _icon;
			};
			if (isClass(configFile >> "CfgWeapons" >> _item)) then {
				(_display displayCtrl 9611) ctrlSetStructuredText parseText getText(configFile >> "CfgWeapons" >> _item >> "descriptionShort");
			};
			if (isClass(configFile >> "CfgVehicles" >> _item)) then {
				if (["B_",_item, true] call BIS_fnc_inString) then {
					(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
						"%2: %1",
						round ((getNumber(configFile >> "CfgVehicles" >> _item >> "maximumload")) / 4),
						["backpackSize"] call cat_trade_fnc_getText
					];
				};
			};			
			if (_magCount isEqualTo -1) then {
				private _section = switch (true) do {
					case (isClass(configFile >> "CfgMagazines" >> _item)): {"CfgMagazines"};
					case (isClass(configFile >> "CfgWeapons" >> _item)): {"CfgWeapons"};
					case (isClass(configFile >> "CfgVehicles" >> _item)): {"CfgVehicles"};
					case (isClass(configFile >> "CfgGlasses" >> _item)): {"CfgGlasses"};
					default {"CfgWeapons"};
				};
				(_display displayCtrl 9609) ctrlSetStructuredText parseText format ["%1",(getText(configFile >> _section >> _item >> "displayName"))];
			} else {
				(_display displayCtrl 9609) ctrlSetStructuredText parseText format ["(%2) %1",(getText(configFile >> "CfgMagazines" >> _item >> "displayName")),_magCount];
				(_display displayCtrl 9609) ctrlSetTooltip format ["%1 - %3: %2",(getText(configFile >> "CfgMagazines" >> _item >> "displayName")),_magCount,(["ammoCount"] call cat_trade_fnc_getText)];
			};
		};
		
    };
    case 1 : {
		ctrlShow[9623,false];
		private _itemObject = objectFromNetId _item;
        (_display displayCtrl 9607) ctrlSetText format[["vehicles"] call cat_trade_fnc_getText];
        (_display displayCtrl 9608) ctrlSetText format[["vehicle"] call cat_trade_fnc_getText];
        private _color = "";
        if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
            _color = ((getArray(missionConfigFile >> "LifeCfgVehicles" >> (typeOf _itemObject) >> "textures") select (_itemObject getVariable "Life_VEH_color")) select 0);
        } else {
            _color = [(typeOf _itemObject),(_itemObject getVariable "Life_VEH_color")] call life_fnc_vehicleColorStr;
        };
		if (isNil "_color") then {_color = ""};
        private _text = format ["(%1)",_color];
        if (_text == "()") then {
            _text = "";
        };

        private _name = getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "displayName");
        private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "picture");
        if (_pic != "pictureStaticObject") then {
            (_display displayCtrl 9609) ctrlSetStructuredText parseText format ["<img image='%5'/>%1 %3 - [%4: %2m]",_name,round(player distance _itemObject),_text,["distance"] call cat_trade_fnc_getText,_pic];
        } else {
            (_display displayCtrl 9609) ctrlSetStructuredText parseText format ["%1 %3 - [%4: %2m]",_name,round(player distance _itemObject),_text,["distance"] call cat_trade_fnc_getText];
        };

        private _vehicleInfo = [typeOf _itemObject] call life_fnc_fetchVehInfo;
		private _trunkSpace = [typeOf _itemObject] call life_fnc_vehicleWeightCfg;
		_details ctrlSetStructuredText parseText format [
			"%7 %1 km/h<br/>" +
			"%8 %2<br/>" +
			"%9 %3<br/>" +
			"%10 %4<br/>" +
			"%11 %5<br/>" +
			"%12 %6",
			(_vehicleInfo select 8),
			(_vehicleInfo select 11),
			(_vehicleInfo select 10),
			if (_trunkSpace isEqualTo -1) then {"None"} else {_trunkSpace},
			(_vehicleInfo select 12),
			(_vehicleInfo select 9),
			["maxSpeed"] call cat_trade_fnc_getText,
			["hPower"] call cat_trade_fnc_getText,
			["pSeats"] call cat_trade_fnc_getText,
			["trunk"] call cat_trade_fnc_getText,
			["fuel"] call cat_trade_fnc_getText,
			["armor"] call cat_trade_fnc_getText
		];

		_marker setMarkerPosLocal visiblePosition _itemObject;
		_marker setMarkerTypeLocal "mil_arrow";
		_marker setMarkerDirLocal 180;
		_marker setMarkerTextLocal format ["%1",getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "displayName")];
		_marker setMarkerColorLocal "ColorBLUFOR";

		_map ctrlMapAnimAdd[1,0.2,getMarkerPos _marker];
		ctrlMapAnimCommit (_display displayCtrl 9612);
    };
    case 2 : {
		ctrlShow[9623,false];
		_itemObject = objectFromNetId _item;
        (_display displayCtrl 9607) ctrlSetText format[["houses"] call cat_trade_fnc_getText];
        (_display displayCtrl 9608) ctrlSetText format[["house"] call cat_trade_fnc_getText];
        private _name = getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "displayName");
        private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "picture");
        if (_pic != "pictureStaticObject") then {
            (_display displayCtrl 9609) ctrlSetStructuredText parseText format ["<img='%4' />%1 - [%3: %2m]",_name,round(player distance _itemObject),["distance"] call cat_trade_fnc_getText,_pic];
        } else {
            (_display displayCtrl 9609) ctrlSetStructuredText parseText format ["%1 - [%3: %2m]",_name,round(player distance _itemObject),["distance"] call cat_trade_fnc_getText];
        };

        private _houseCfg = [typeOf _itemObject] call life_fnc_houseConfig;
		private _containers = _itemObject getVariable ["containers",[]];
		if !(("cat_alarm_fnc_getText" call BIS_fnc_functionPath) isEqualTo "") then {
			private _security = if(_itemObject getVariable ["security",false]) then {["yes"] call cat_trade_fnc_getText} else {["no"] call cat_trade_fnc_getText};
			_details ctrlSetStructuredText parseText format [
				"%1 %4<br/>" +
				"%2 %5<br/>" +
				"%6: %3",
				(_houseCfg select 1),
				(count _containers),
				_security,
				["numberCrates"] call cat_trade_fnc_getText,
				["numberCratesInstalled"] call cat_trade_fnc_getText,
				["securityInstalled"] call cat_trade_fnc_getText
			];
		} else {
			_details ctrlSetStructuredText parseText format [
				"%1 %3<br/>" +
				"%2 %4",
				(_houseCfg select 1),
				(count _containers),
				["numberCrates"] call cat_trade_fnc_getText,
				["numberCratesInstalled"] call cat_trade_fnc_getText
			];
		};

        _marker setMarkerPosLocal visiblePosition _itemObject;
		_marker setMarkerTypeLocal "mil_arrow";
		_marker setMarkerDirLocal 180;
		_marker setMarkerTextLocal format ["%1",getText(configFile >> "CfgVehicles" >> (typeOf _itemObject) >> "displayName")];
		_marker setMarkerColorLocal "ColorBLUFOR";

		_map ctrlMapAnimAdd[1,0.2,getMarkerPos _marker];
		ctrlMapAnimCommit _map;
    };
};

_checkbox ctrlSetChecked false;

_display setVariable ["item",_item];
_display setVariable ["vendor",_vendor];
_display setVariable ["price",_price];
_display setVariable ["amount",_amount];
_display setVariable ["case",_case];
_display setVariable ["itemType",_itemType];
_display setVariable ["magCount",_magCount];