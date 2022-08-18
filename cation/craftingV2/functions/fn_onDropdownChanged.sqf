/*
    File: fn_onDropdownChanged.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Called when dialog dropdown changed. Mainly used for selecting category of crafting items and plans
*/
params ["_control", "_selectedIndex"];

disableSerialization;

private _display = findDisplay 5100; // get dialog
private _mode = _display getVariable "mode"; // get mode
private _listbox = (_display displayCtrl 5105); // get listbox
lbClear _listbox; // clear listbox

if (_mode isEqualTo "plans") then { // plans
	{		
		private _varname = getText(_x >> "variable"); // get variable name
		private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};}; // get side
		private _plan = format["cat_crafting_plan_%1_%2",_flag,getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _varname >> "variable")]; // get plan
		private _owned = (missionNamespace getVariable [_plan,false]); // get boolean if plan is owned
		if (_selectedIndex isEqualTo 0 || {_selectedIndex isEqualTo 1 && _owned} || {_selectedIndex isEqualTo 2 && !_owned}) then { // show if (showAllPlans OR showOnlyOwnedPlans + plan owned OR showOnlyNotOwnedPlans + plan not owned)
			private _displayName = getText(_x >> "displayName"); // get displayname
			private _icon = getText(_x >> "icon"); // get icon
			_listbox lbAdd localize _displayName; // add new entry
			if !(_icon isEqualTo "") then { // if icon is available
				_listbox lbSetPicture [(lbSize _listbox)-1,_icon]; // set icon
			};
			_listbox lbSetData[(lbSize _listbox)-1,_varname]; // set variablename of plan to new entry
			if (_owned) then { // if plan is owned
				_listbox lbSetColor [(lbSize _listbox)-1, [0.204,0.824,0.576,1]]; // set text color green
				_listbox lbSetSelectColor [(lbSize _listbox)-1, [0.204,0.824,0.576,1]]; // set text color green
			} else { // else plan not owned
				_listbox lbSetColor [(lbSize _listbox)-1, [0.914,0.4,0.337,1]]; // set text color red
				_listbox lbSetSelectColor [(lbSize _listbox)-1, [0.914,0.4,0.337,1]]; // set text color red
			};
		};
	} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "plans")); // all crafting plans
	if ((lbSize _listbox) isEqualTo 0) then { // if no entries
		_listbox lbAdd format[["NoPlans"] call cat_craftingV2_fnc_getText]; // set text: no plans
		_listbox lbSetData[(lbSize _listbox)-1,"NoPlans"]; // set data: no plans
	};
	_listbox lbSetCurSel 0; // select first plan
} else { // items
	private _category = _control lbData _selectedIndex; // get category from selected dropdown index
	_display setVariable ["category",_category]; // set category dialog variable
	if (_category isEqualTo "NoCategories") exitWith { // no items available
		_listbox lbAdd format[["NoItems"] call cat_craftingV2_fnc_getText]; // set text: no items
		_listbox lbSetData[(lbSize _listbox)-1,"NoItems"]; // set data: no items
	};
	{
		private _displayName = getText(_x >> "displayName"); // get displayname
		if ([getText(_x >> "conditions")] call cat_craftingV2_fnc_levelCheck) then { // if all requirements are met
			private _varname = configName _x; // get configName
			private _icon = ""; // initialize variable
			private _displayName = ""; // initialize variable
			if (getNumber(_x >> "vItem") isEqualTo 1) then { // is vItem
				_displayName = localize (getText(missionConfigFile >> "VirtualItems" >> _varname >> "displayName")); // get displayname
				_icon = getText(missionConfigFile >> "VirtualItems" >> _varname >> "icon"); // get icon
			} else { // no vItem -> Arma Item
				private _itemInfo = [_varname] call life_fnc_fetchCfgDetails; // get item info
				if ((getText(_x >> "skin")) isEqualTo "") then { // no skin available
					_displayName = _itemInfo select 1; // get displayname
				} else { // if skin available
					_displayName = format["%1 - %2",_itemInfo select 1,getText(_x >> "skin")]; // get displayname including skinname
				};
				_icon = _itemInfo select 2; // get icon
			};
			private _nickName = getText (_x >> "nickname"); // get variable nickname
			if (!(_nickName isEqualTo "")) then { // nickname defined
				_displayName = localize _nickName; // set displayname to localized nickname
			};
			_listbox lbAdd _displayName; // add new entry
			if !(_icon isEqualTo "") then { // if icon found
				_listbox lbSetPicture [(lbSize _listbox)-1,_icon]; // set icon
			};
			_listbox lbSetData[(lbSize _listbox)-1,_varname]; // set variablename of icon to new entry
			private _reqLevel = getText(_x >> "minlevel"); // get minimum required level
			private _reqLevelNumber = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "levels" >> _reqLevel >> "value"); // get minimum required level number
			private _ownLevelNumber = missionNamespace getVariable ["cat_crafting_level",0]; // get crafting level of player
			private _flag = switch (playerSide) do {case west: {"cop"}; case civilian: {"civ"}; case independent: {"med"}; case east: {"east"};}; // get side
			private _planName = getText(_x >> "plan"); // get required plan name
			private _reqPlan = format["cat_crafting_plan_%1_%2",_flag,_planName]; // get required plan variable name
			private _plan = true; // initialize variable
			if !(_planName isEqualTo "") then { // if a plan is required
				_plan = (missionNamespace getVariable [_reqPlan,false]); // boolean if required plan is owned
			};
			if (_plan && _ownLevelNumber >= _reqLevelNumber) then { // if plan is owned and required level has been reached
				_listbox lbSetColor [(lbSize _listbox)-1, [0.204,0.824,0.576,1]]; // set text color green
				_listbox lbSetSelectColor [(lbSize _listbox)-1, [0.204,0.824,0.576,1]]; // set text color green
			} else { // plan is not owned or required level has not been reached
				_listbox lbSetColor [(lbSize _listbox)-1, [0.914,0.4,0.337,1]]; // set text color red
				_listbox lbSetSelectColor [(lbSize _listbox)-1, [0.914,0.4,0.337,1]]; // set text color red
			};
		};
	} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _category)); // iterate over items of given category
	_listbox lbSetCurSel 0; // select first item
};