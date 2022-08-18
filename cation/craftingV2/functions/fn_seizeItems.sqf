/*
    File: fn_seizeItems.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Seizes items from player inventory and locker. The selected storage space is prioritised. Returns an array with information how many items were removed from which inventory.
*/
params [
	["_itemsNeeded",[],[[]]],
	["_amount",1,[0]],
	["_location",0,[0]]
];

private _itemsPlayer = [] call cat_craftingV2_fnc_getItemsPlayer; // get items from player inventory - format: [[variable,amount],[variable,amount],...]
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] items player: %1",_itemsPlayer]; // log entry
};
private _itemsLocker = []; // initialize array
if !(("cat_locker_fnc_getText" call BIS_fnc_functionPath) isEqualTo "") then { // if locker system is installed
	_itemsLocker = [] call cat_craftingV2_fnc_getItemsLocker; // get items from locker inventory - format: [[variable,amount],[variable,amount],...]
};
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] items locker: %1",_itemsLocker]; // log entry
};

private _return = [[],[]]; // initialize return variable

{ // all items needed
	private _itemNeeded = _x select 0; // get needed item
	private _amountNeeded = (_x select 1) * _amount; // get needed amount multiplied by amount of crafted items
	private _index = _forEachIndex; // get current index
	_itemsNeeded set [_index,[_itemNeeded,_amountNeeded]]; // set multiplied amount
	if (_location isEqualTo 0) then { // take it from prefered storage: player inventory
		{
			private _itemPlayer = _x select 0; // get player item
			private _amountPlayer = _x select 1; // get amount of item 
			if (_itemPlayer isEqualTo _itemNeeded) then { // if item is equal to needed item
				private _amount = _amountNeeded - _amountPlayer; // sub amount of player from needed amount
				if (_amount > 0) then { // if needed amount is greater than player amount
					_itemsNeeded set [_index,[_itemNeeded,_amount]]; // sub player amount from needed item position
					[false,_itemNeeded,_amountPlayer] call life_fnc_handleInv; // remove item from player inventory
					(_return select 0) pushBack [_itemNeeded,_amountPlayer]; // add item and taken amount to return variable
				} else { // else needed amount is lower or equal to player amount
					_itemsNeeded set [_index,[_itemNeeded,0]]; // set amount needed on item position to 0
					[false,_itemNeeded,_amountNeeded] call life_fnc_handleInv; // remove item from player inventory
					(_return select 0) pushBack [_itemNeeded,_amountNeeded]; // add item and taken amount to return variable
				};
			};
		} forEach _itemsPlayer; // player items - format: [[variable,amount],[variable,amount],...]
		{
			private _itemLocker = _x select 0; // get locker item
			if (_itemLocker isEqualTo _itemNeeded) then {// if item is equal to needed item
				_amountNeeded = (_itemsNeeded select _index) select 1; // get needed amount
				if (_amountNeeded > 0) then { // if needed amount greater than 0
					[false,_itemNeeded,_amountNeeded] call cat_craftingV2_fnc_handleInvLocker; // remove item from locker inventory
					(_return select 1) pushBack [_itemNeeded,_amountNeeded]; // add item and taken amount to return variable
				};
			};
		} forEach _itemsLocker; // locker items - format: [[variable,amount],[variable,amount],...]
	} else { // else prefered storage: locker inventory
		{
			private _itemLocker = _x select 0; // get locker item
			private _amountLocker = _x select 1; // get amount of item
			if (_itemLocker isEqualTo _itemNeeded) then { // if item is equal to needed item
				private _amount = _amountNeeded - _amountLocker; // sub amount of locker from needed amount
				if (_amount > 0) then { // if needed amount is greater than locker amount
					_itemsNeeded set [_index,[_itemNeeded,_amount]]; // sub locker amount from needed item position
					[false,_itemNeeded,_amountLocker] call cat_craftingV2_fnc_handleInvLocker; // remove item from locker inventory
					(_return select 1) pushBack [_itemNeeded,_amountLocker]; // add item and taken amount to return variable
				} else { // else needed amount is lower or equal to locker amount
					_itemsNeeded set [_index,[_itemNeeded,0]]; // set amount needed on item position to 0
					[false,_itemNeeded,_amountNeeded] call cat_craftingV2_fnc_handleInvLocker; // remove item from locker inventory
					(_return select 1) pushBack [_itemNeeded,_amountNeeded]; // add item and taken amount to return variable
				};
			};
		} forEach _itemsLocker; // locker items - format: [[variable,amount],[variable,amount],...]
		{
			private _itemPlayer = _x select 0; // get player item
			if (_itemPlayer isEqualTo _itemNeeded) then {// if item is equal to needed item
				_amountNeeded = (_itemsNeeded select _index) select 1; // get needed amount
				if (_amountNeeded > 0) then { // if needed amount greater than 0
					[false,_itemNeeded,_amountNeeded] call life_fnc_handleInv; // remove item from player inventory
					(_return select 0) pushBack [_itemNeeded,_amountNeeded]; // add item and taken amount to return variable
				};
			};
		} forEach _itemsPlayer; // player items - format: [[variable,amount],[variable,amount],...]
	}
} forEach _itemsNeeded; // all items needed - format: [[varname,amount],[varname,amount],...]

_return; // return array of take items and taken amount from locker and player inventory