/*
    File: fn_handleInvLocker.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Handles storing and taking items from locker
	Hint: taking items from locker only works for vItems!
	Returns true if successful and false if an error occurred
*/
params [
	["_add",false,[true]],
	["_item","",[""]],
	["_amount",0,[0]],
	["_vItem",true,[true]]
];

if (_item isEqualTo "" || _amount isEqualTo 0) exitWith {false}; // return error if wrong variables inputted

private _return = true; // initialize return variable
private _index = -1; // initialize index
private _lockerItems = cat_locker_trunk; // get all locker items

private _type = [_item,_vItem] call cat_craftingV2_fnc_getLockerItemType; // get type

// Get index if item is already in locker inventory, else index is -1
{ // all locker items
	private _curType = (_x select 0); // Type
	if (_curType isEqualTo _type) then { // if type is the same
		private _curVal = (_x select 2); // amount
		if (_curVal > 0) then { // if amount greater 0
			private _curVar = (_x select 1); // varname
			if (_curVar isEqualTo _item) then { // if varname = item
				if (_vItem) then { // if vItem
					_index = _forEachIndex; // save index
				} else {
					if !(isClass(configFile >> "CfgMagazines" >> _item)) then { // if no magazine
						_index = _forEachIndex; // save index
					} else { // if magazine
						if ((getNumber(configFile >> "CfgMagazines" >> _item >> "count")) isEqualTo (_x select 3)) then { // if magazine count equals current item ammo count
							_index = _forEachIndex; // save index
						};
					};
				};
			};
		};
	};
} forEach _lockerItems; // all locker items

try {
	if (_add) then { // if add
		if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    		diag_log format["cationstudio crafting: [INFO] Adding item %1, type %2, amount %3 to locker. Function cat_craftingV2_fnc_handleInvLocker", _item, _type, _amount]; // log entry
		};
		if (_type isEqualTo -1) throw "cannot store items: type is undefined";
		private _amountOfItems = [_item,_vItem] call cat_craftingV2_fnc_canStoreLocker; // get amount of item which can be stored in locker
		if (_amount > _amountOfItems) throw "cannot store items: no space";
		private _ammoCount = -1; // set ammo count to -1
		if (isClass(configFile >> "CfgMagazines" >> _item)) then { // if magazin
			_ammoCount = getNumber(configfile >> "CfgMagazines" >> _item >> "count"); // set ammoCount
		};
		if (_index isEqualTo -1) then { // if item is not in locker yet
			_lockerItems pushBack [_type,_item,_amount,_ammoCount]; // add item to locker inventory
		} else { // else item is in locker
			_lockerItems set[_index,[_type,_item,(((_lockerItems select _index) select 2) + _amount),_ammoCount]]; // add amount to item
		};
	} else { // else sub
		if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    		diag_log format["cationstudio crafting: [INFO] Taking item %1, type %2 from locker. Function cat_craftingV2_fnc_handleInvLocker", _item, _type]; // log entry
		};
		if !(_vItem) throw "Sub only works for vItems";
		if (_index isEqualTo -1) throw "item not found";
		if (_amount > ((_lockerItems select _index) select 2)) throw "not enough items";
		if (_amount isEqualTo ((_lockerItems select _index) select 2)) then { // if amout = stored amount of items
			_lockerItems deleteAt _index; // delete item at index
		} else {
			_lockerItems set[_index,[0,_item,(((_lockerItems select _index) select 2) - _amount),-1]]; // sub amount of items at index
		};
	};
} catch { // catch error
	_return = false; // set return value to false
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
        diag_log format["cationstudio crafting: [ERROR] cat_craftingV2_fnc_handleInvLocker: %1",_exception]; // log entry
    };
};

if (_return) then { // if no error
	cat_locker_trunk = _lockerItems; // save locker inventory
    if (getNumber(missionConfigFile >> "Cation_Locker" >> "HeadlessSupport") isEqualTo 0) then { // if headless client is not enabled
        [cat_locker_trunk,cat_locker_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunk",2]; // send update method to server
    } else { // else headless client is eabled
        if (life_HC_isActive) then { // if headless client is active
            [cat_locker_trunk,cat_locker_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunkHC",HC_Life]; // send update method to headless client
        } else { // else if headless client is not active
            [cat_locker_trunk,cat_locker_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunk",2]; // send update method to server
        };
    };
};

_return; // return boolean: true = everything is fine | false = an error occurred