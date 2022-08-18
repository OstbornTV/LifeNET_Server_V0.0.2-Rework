/*
    File: fn_getItems.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns items stored in player inventory and in locker.
*/

private _items = [] call cat_craftingV2_fnc_getItemsPlayer; // get player items

if !(("cat_locker_fnc_getText" call BIS_fnc_functionPath) isEqualTo "") then { // if locker system is installed
	private _lockerItems = [] call cat_craftingV2_fnc_getItemsLocker; // get locker items
	{ // all player items
		private _currentItem = _x; // get player item at index
		private _currentItemVar = _x select 0; // variable name of item at index
		private _currentItemIndex = _forEachIndex; // get index
		{ // all locker items
			private _currentLockerItem = _x; // get locker item at index
			private _currentLockerItemVar = _currentLockerItem select 0; // variable name of item at index
			if (_currentItemVar isEqualTo _currentLockerItemVar) then { // if variable names are the same
				private _currentItemCount = _currentItem select 1; // get amount of player item
				private _currentLockerItemCount = _currentLockerItem select 1; // get amount of locker item
				_currentItem set [1,(_currentItemCount+_currentLockerItemCount)]; // addition of amounts and save it to player item
				_items set [_currentItemIndex,_currentItem]; // save player item in player items array
				_lockerItems deleteAt _forEachIndex; // delete item from locker items array
			}
		} forEach _lockerItems; // all locker items
	} forEach _items; // all player items
	_items append _lockerItems; // append the rest of locker items to player items
} else {
	_items append []; // add empty array for locker
};

_items; // return items - format: [[variable,amount],[variable,amount],...]