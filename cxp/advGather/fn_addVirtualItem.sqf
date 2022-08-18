/*
	Author: Casperento
	
	Description:
	Store selected item into player's backpack

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_varName", "", [""]],
	["_weight", 0, [-1]],
	["_amount", 0, [-1]]
];

if (isNil "cxpadg_menuOpened" || _varName isEqualTo "" || _amount isEqualTo 0 || _weight isEqualTo 0) exitWith {false};

private _varName = "life_inv_" + _varName;
private _currentAmount = missionNamespace getVariable [_varName, 0];
private _totalAmount = _currentAmount + _amount;
private _totalWeight = _amount * _weight;

if (_totalWeight + life_carryWeight > life_maxWeight) exitWith {false};

missionNamespace setVariable [_varName, _totalAmount];
life_carryWeight = life_carryWeight + _totalWeight;
true