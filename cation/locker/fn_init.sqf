/*
    File: fn_init.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Initializes locker inventory.
*/
params [
    ["_inv",[],[[]]],
    ["_level",0,[0]]
];

cat_locker_trunk = _inv;
cat_locker_level = _level;
private _sizePrice = (getArray(missionConfigFile >> "Cation_Locker" >> "locker_size_price"));
if (_level isEqualTo 0) then {
    cat_locker_maxWeight = 0;
} else {    
    cat_locker_maxWeight = (_sizePrice select (_level-1)) select 0;
};
private _carryWeight = 0;
{
    private _val = _x select 2;
    _carryWeight = _carryWeight + (([_x select 1,_x select 0] call cat_locker_fnc_itemWeight) * _val);
} forEach cat_locker_trunk;
cat_locker_carryWeight = _carryWeight;