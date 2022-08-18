/*
    File: fn_canStoreLocker.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
     Returns how many items can be stored in locker inventory.
*/
params [
	["_item","",[""]],
	["_vItem",false,[false]]
];
private _return = 0; // return variable

private _carryWeight = 0; // set carryWeight to 0
{
    private _val = _x select 2; // get item count
    _carryWeight = _carryWeight + (([_x select 1,_x select 0] call cat_locker_fnc_itemWeight) * _val); // calculate locker carry weight
} forEach cat_locker_trunk;
cat_locker_carryWeight = _carryWeight; // set carry weight
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
    diag_log format["cationstudio crafting: [INFO] locker carry weight: %1",cat_locker_carryWeight]; // log entry
};
private _type = [_item,_vItem] call cat_craftingV2_fnc_getLockerItemType; // get type
private _weight = [_item,_type] call cat_locker_fnc_itemWeight; // get weight
_return = floor ((cat_locker_maxWeight - cat_locker_carryWeight) / _weight); // calculate item amount

_return;