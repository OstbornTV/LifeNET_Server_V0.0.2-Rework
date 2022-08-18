/*
    File: fn_getItemsPlayer.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Returns items stored in player inventory.
*/
private _playerItems = []; // initialize player items array
private _items = []; // initialize item array
if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 3) then { // if altis life version greater 3
    _playerItems = ("true" configClasses (missionConfigFile >> "VirtualItems")); // get virtual items
} else {
    _playerItems = life_inv_items; // get virtual items
};
{
    private _val = 0; // initialize variable amount
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 3) then { // if altis life version greater 3
        _val = missionNamespace getVariable [format["life_inv_%1",(getText(missionConfigFile >> "VirtualItems" >> (configName _x) >> "variable"))],0]; // amount
    } else {
        _val = missionNamespace getVariable [_x,0]; // amount
    };
    if (_val > 0) then { // if amount greater 0
        private _var = ""; // initialize variable varname
    	if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "version")) > 3) then { // if altis life version greater 3
            _var = configName _x; // get varname
    	} else {
            _var = [_x,1] call life_fnc_varHandle; // get varname
        };
		_items pushBack [_var,_val]; // push data to items array
    };
} forEach _playerItems; // all player items

_items; // return item array - format: [[variable,amount],[variable,amount],...]