/*
    File: fn_openVendorLBItemChange.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	changes item description/icon of vendor dialog
*/

disableSerialization;
private _data = (_this select 0) lbData (_this select 1);
private _value = (_this select 0) lbValue (_this select 1);

if (_data isEqualTo "") exitWith {};

_data = _data splitString ";";
private _case = parseNumber (_data select 0);

private _display = (findDisplay 9600);
(_display displayCtrl 9611) ctrlSetStructuredText parseText "";
(_display displayCtrl 9614) ctrlSetTooltip "";
(_display displayCtrl 9623) ctrlSetText "";

switch (_case) do {
	case 0 : {		
		private _item = _data select 2;
		if ((parseNumber(_data select 1)) isEqualTo 1) then {
			ctrlEnable [9614,true];
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
        	if ((getNumber(missionConfigFile >> "Cation_Trade" >> "version")) > 3) then {
				private _icon = "";
                _icon = getText(missionConfigFile >> "VirtualItems" >> _item >> "icon");
				if (!(_icon isEqualTo "")) then {
					(_display displayCtrl 9623) ctrlSetText _icon;
				};
            };
		} else {
			private _itemInfo = [_item] call life_fnc_fetchCfgDetails;
			private _icon = "";
			_icon = (_itemInfo select 2);
			if (!(_icon isEqualTo "")) then {
				(_display displayCtrl 9623) ctrlSetText _icon;
			};
			if (isClass(configFile >> "CfgWeapons" >> _item)) then {
				(_display displayCtrl 9611) ctrlSetStructuredText parseText format["%1<br>%2",getText(configFile >> "CfgWeapons" >> _item >> "descriptionShort"),["warningItems"] call cat_trade_fnc_getText];
			};
			if (isClass(configFile >> "CfgVehicles" >> _item)) then {
				if (["B_",_item, true] call BIS_fnc_inString) then {
					(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
						"%2: %1<br/>%3",
						round ((getNumber(configFile >> "CfgVehicles" >> _item >> "maximumload")) / 4),
						["backpackSize"] call cat_trade_fnc_getText,
						["warningItems"] call cat_trade_fnc_getText
					];
				};
			};
			if ((vest player isEqualTo _item) || (uniform player isEqualTo _item)) then {
				(_display displayCtrl 9611) ctrlSetStructuredText parseText format[["warningItems"] call cat_trade_fnc_getText];
			};	
			if ((getNumber(configFile >> "CfgWeapons" >> _item >> "type") in [1,2,4]) || isClass(configfile >> "CfgVehicles" >> _item)) then {
				ctrlEnable [9614,false];
				(_display displayCtrl 9614) ctrlSetTooltip format[["infoSellSeparate"] call cat_trade_fnc_getText];
			} else {
				ctrlEnable [9614,true];
			};
		};
		(_display displayCtrl 9614) ctrlSetText "1";
	};
	case 1 : {
		private _veh = objectFromNetId (_data select 1);
		private _vehicleInfo = [typeOf _veh] call life_fnc_fetchVehInfo;
		private _trunkSpace = [typeOf _veh] call life_fnc_vehicleWeightCfg;
		(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
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

		private _marker = "cat_trade_marker";
		_marker setMarkerPosLocal visiblePosition _veh;
		_marker setMarkerTypeLocal "mil_arrow";
		_marker setMarkerDirLocal 180;
		_marker setMarkerTextLocal format ["%1",getText(configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName")];
		_marker setMarkerColorLocal "ColorBLUFOR";

		(_display displayCtrl 9612) ctrlMapAnimAdd[1,0.2,getMarkerPos _marker];
		ctrlMapAnimCommit (_display displayCtrl 9612);
	};
	case 2 : {
		private _house = objectFromNetId (_data select 1);
		private _houseCfg = [typeOf _house] call life_fnc_houseConfig;
		private _containers = _house getVariable ["containers",[]];
		if !(("cat_alarm_fnc_getText" call BIS_fnc_functionPath) isEqualTo "") then {
			private _security = if(_house getVariable ["security",false]) then {["yes"] call cat_trade_fnc_getText} else {["no"] call cat_trade_fnc_getText};
			(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
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
			(_display displayCtrl 9611) ctrlSetStructuredText parseText format [
				"%1 %3<br/>" +
				"%2 %4",
				(_houseCfg select 1),
				(count _containers),
				["numberCrates"] call cat_trade_fnc_getText,
				["numberCratesInstalled"] call cat_trade_fnc_getText
			];
		};

		private _marker = "cat_trade_marker";
		_marker setMarkerPosLocal visiblePosition _house;
		_marker setMarkerTypeLocal "mil_arrow";
		_marker setMarkerDirLocal 180;
		_marker setMarkerTextLocal format ["%1",getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName")];
		_marker setMarkerColorLocal "ColorBLUFOR";

		(_display displayCtrl 9612) ctrlMapAnimAdd[1,0.2,getMarkerPos _marker];
		ctrlMapAnimCommit (_display displayCtrl 9612);
	};
};