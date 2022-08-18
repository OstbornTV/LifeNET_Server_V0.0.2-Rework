/*
    File: fn_onItemListChanged.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Called when new item in listbox is selected. Used to show detailed info of crafting item or plan.
*/
params ["_control", "_selectedIndex"];

disableSerialization;

private _item = _control lbData _selectedIndex; // get selected item
private _display = findDisplay 5100; // get dialog
private _mode = _display getVariable "mode"; // get mode
private _itemInfoBox = (_display displayCtrl 5109); // get item info box
if (_mode isEqualTo "items") then { // show item info
	if (_item isEqualTo "NoItems") exitWith { // no items available
		_itemInfoBox ctrlSetStructuredText parseText format["<t size='3'>%1</t>",["NoItems"] call cat_craftingV2_fnc_getText]; // set text: no items
	};
	private _category = _display getVariable "category"; // get category variable saved in dialog
	private _displayName = ""; // initialize variable
	private _icon = ""; // initialize variable
	if (getNumber(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "vItem") isEqualTo 1) then { // is vItem
		_displayName = localize (getText(missionConfigFile >> "VirtualItems" >> _item >> "displayName")); // get displayname
		_icon = getText(missionConfigFile >> "VirtualItems" >> _item >> "icon"); // get icon
	} else { // else ArmA Item
		private _itemInfo = [_item] call life_fnc_fetchCfgDetails; // get item info
		if ((getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skin")) isEqualTo "") then { // no skin available
			_displayName = _itemInfo select 1; // get displayname
		} else { // skin available
			_displayName = format["%1 - %2",_itemInfo select 1,getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "skin")]; // get displayname including skin name
		};
		_icon = _itemInfo select 2; // get icon
	};
	if !(_icon isEqualTo "") then { // if icon found
		ctrlSetText [5111,_icon]; // show picture
	};
	private _nickName = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "nickname"); // get variable nickname
	if (!(_nickName isEqualTo "")) then { // nickname defined
		_displayName = localize _nickName; // set displayname to localized nickname
	};
	private _infoText = format["<t size='3'>%1</t>",_displayName]; // set heading: item name
	private _reqPlan = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "plan"); // get required plan for item
	private _owned = false; // initialize variable
	if !(_reqPlan isEqualTo "") then { // if plan required
		private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};}; // get side
    	private _plan = format["cat_crafting_plan_%1_%2",_flag,getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _reqPlan >> "variable")]; // build plan variable string
		_owned = (missionNamespace getVariable [_plan,false]); // boolean if plan is owned
	};
	if (_owned || _reqPlan isEqualTo "") then { // if plan owned or no plan required
		if (_reqPlan isEqualTo "") then { // if no plan is required
			_infoText = _infoText + format["<br/><br/><t size='1.5'>%1</t>",["NoPlanRequired"] call cat_craftingV2_fnc_getText]; // set text: no plan required
		} else { // if plan is required
			private _planDisplayName = localize getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _reqPlan >> "displayName"); // get plan display name
			_infoText = _infoText + format["<br/><br/><t size='1.5'>%1 %2 %3</t>",["RequiredPlan"] call cat_craftingV2_fnc_getText,_planDisplayName,["Available"] call cat_craftingV2_fnc_getText]; // set text: plan required and available
		};
		_infoText = _infoText + format["<br/><br/><t size='1.5'>%1:</t><br/>",["RequiredItems"] call cat_craftingV2_fnc_getText]; // set text: required items
		{
			private _varname = _x select 0; // get varname
			private _amount = _x select 1; // get amount
			private _displayName = localize getText(missionConfigFile >> "VirtualItems" >> _varname >> "displayName"); // get display name
            private _icon = getText(missionConfigFile >> "VirtualItems" >> _varname >> "icon"); // get icon
			_infoText = _infoText + format["<t size='1.3'>%1x <img image='%2'/> %3</t><br/>",_amount,_icon,_displayName]; // show required items and required level
		} forEach getArray(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "itemsReq"); // for each required item
		private _reqLevel = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "minlevel"); // get required level
		private _reqLevelNumber = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "levels" >> _reqLevel >> "value"); // get required level number
		private _ownLevelNumber = missionNamespace getVariable ["cat_crafting_level",0]; // get player's level
		private _reqLevelDisplayName = [getText(missionConfigFile >> "Cation_CraftingV2" >> "levels" >> _reqLevel >> "displayName")] call cat_craftingV2_fnc_getText; // get display name of player's level
		if (_ownLevelNumber >= _reqLevelNumber) then { // if required level is reached
			ctrlEnable [5110, true]; // enable craft button
		} else { // if required level is not reached
			ctrlEnable [5110, false]; // disable craft button
		};
		_infoText = _infoText + format["<br/><t size='1.5'>%1: %2 (%3)",["RequiredLevel"] call cat_craftingV2_fnc_getText,_reqLevelDisplayName,_reqLevelNumber]; // set text: required level
		ctrlEnable [5113, true]; // enable amount text field
		if (isClass(configFile >> "CfgVehicles" >> _item)) then { // if item is in CfgVehicles
			private _parents = [(configfile >> "CfgVehicles" >> _item),true] call BIS_fnc_returnParents; // get parent classes
			if ("AllVehicles" in _parents) then {// is vehicle
				private _station = _display getVariable ["station",""]; // get crafting station
				private _spawnPointMarker = getText(missionConfigFile >> "Cation_CraftingV2" >> "stations" >> _station >> "spawnmarker"); // get markername from config
				private _markerPos = getMarkerPos _spawnPointMarker; // get marker position
				if (_markerPos isEqualTo [0,0,0]) then { // marker not found
					ctrlEnable [5110, false]; // disable craft button
					_infoText = _infoText + format["<br/><br/><t size='1.5'>%1: %2",["Spawnpoint"] call cat_craftingV2_fnc_getText,["NotFound"] call cat_craftingV2_fnc_getText]; // set text: spawnpoint not found
				} else { // marker found
					ctrlEnable [5113, false]; // disable amount text field
					ctrlSetText [5113, "1"]; // set amount to 1
					private _location = text ((nearestLocations [getMarkerPos _spawnPointMarker,["NameCityCapital","NameCity","NameVillage"],10000]) select 0); // get neareast city/village
					_infoText = _infoText + format["<br/><br/><t size='1.5'>%1: %2 (%3m)",["Spawnpoint"] call cat_craftingV2_fnc_getText,_location,round(player distance2D _markerPos)]; // set text: neareast city/village and distance
				};
			};
		};
		private _points = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category >> _item >> "ep"); // get ep for item from config
		if (_points < 0) then { // if experience points for item are negative
			if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
				diag_log format["cationstudio crafting: [WARNING] experience points (ep) for item %1 in category %1 is negative. Using default value 1. Funtion cat_craftingV2_fnc_onItemListChanged", _item, _category]; // log entry
			};
			_points = 1; // default it to 1
		};
		if (_points == 0) then { // if experience points for item is 0, value is set to 0 or is unset.
			_points = 1; // default it to 1
		};
		_infoText = _infoText + format["<br/><br/><t size='1.5'>%1: %2</t>",["ExperiencePoints"] call cat_craftingV2_fnc_getText,_points]; // set text: Experience Points
	} else { // if plan not owned but required
		ctrlEnable [5110, false]; // disable craft button
		private _planDisplayName = localize getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _reqPlan >> "displayName"); // get display name of required plan
		_infoText = _infoText + format["<br/><br/><t size='1.5'>%1 %2 %3.</t>",["RequiredPlan"] call cat_craftingV2_fnc_getText,_planDisplayName,["NotLearned"] call cat_craftingV2_fnc_getText]; // set text: required plan not learnt yet
	};
	_itemInfoBox ctrlSetStructuredText parseText _infoText; // display text
} else { // show plan info
	if (_item isEqualTo "NoPlans") exitWith { // no items available
		_itemInfoBox ctrlSetStructuredText parseText format["<t size='3'>%1</t>",["NoPlans"] call cat_craftingV2_fnc_getText]; // set text: no plans
	};
	private _displayName = localize (getText(missionConfigFile >> "VirtualItems" >> _item >> "displayName")); // get displayname
	private _icon = getText(missionConfigFile >> "VirtualItems" >> _item >> "icon"); // get icon
	if !(_icon isEqualTo "") then { // if icon found
		ctrlSetText [5111,_icon]; // show picture
	};
	private _rarityVarname = getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _item >> "rarity"); // get plan rarity
	private _rarityDisplayName = [getText(missionConfigFile >> "Cation_CraftingV2" >> "rarities" >> _rarityVarname >> "displayName")] call cat_craftingV2_fnc_getText; // get display name of rarity
	private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};}; // get side
    private _plan = format["cat_crafting_plan_%1_%2",_flag,getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _item >> "variable")]; // get plan
	private _owned = (missionNamespace getVariable [_plan,false]); // boolean if plan is owned
	private _ownedText = ""; // initialize variable
	if (_owned) then { // if plan is owned
		_ownedText = ["Yes"] call cat_craftingV2_fnc_getText; // set text: yes
	} else { // if plan is not owned
		_ownedText = ["No"] call cat_craftingV2_fnc_getText; // set text: no
	};
	_itemInfoBox ctrlSetStructuredText parseText format["<t size='3'>%1</t><br/><br/><t size='1.5'>%2: %3</t><br/><br/><t size='1.5'>%4: %5</t>",_displayName,["Rarity"] call cat_craftingV2_fnc_getText,_rarityDisplayName,["Learned"] call cat_craftingV2_fnc_getText,_ownedText]; // display text
};