/*
    File: fn_getItemsLocker.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns items stored in locker.
*/
private _lockerItems = cat_locker_trunk; // all locker items
private _items = []; // initialize item array
{
	private _type = (_x select 0); // Type
	if (_type isEqualTo 0) then { // if vItem
		private _val = (_x select 2); // amount
		if (_val > 0) then { // amount greater 0
			private _var = (_x select 1); // varname
			_items pushBack [_var,_val]; // push item to array
		};
	};
} forEach _lockerItems; // all locker items

_items; // return item array - format: [[variable,amount],[variable,amount],...]