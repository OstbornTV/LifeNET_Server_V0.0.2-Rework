/*
    File: fn_randomPlan.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Can be called in various situations. Used to randomly add a crafting plan to player inventory.
	Input:
	- chance from 0 to 100 %
	- minRarity from 0 to unlimited
	- maxRarity from 0 to unlimited
*/
params [
	["_chance",50,[0]],
	["_minRarity",0,[0]],
	["_maxRarity",9,[0]]
];

if (_chance < random 100) exitWith {}; // exit if chance lower than random number between 0 and 100

private _craftingPlans = []; // initialize array of crafting plans
{
	private _variable = getText(_x >> "variable"); // get variable name
	private _rarityVarname = getText(_x >> "rarity"); // get rarity varname
	private _rarity = getNumber(missionConfigFile >> "Cation_CraftingV2" >> "rarities" >> _rarityVarname >> "value"); // get rarity number
	if (_rarity >= _minRarity && _rarity <= _maxRarity) then { // if rarity is greater or equal than min rarity AND rarity is lower or equal than max rarity
		for "_i" from _rarity to _maxRarity do { // from rarity to max rarity with step 1 -> the lower the rarity, the more often plan gets added to array
			_craftingPlans pushBack _variable; // add variable name of plan to array
		};
	};
} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "plans")); // for each crafting plan

private _plan = selectRandom _craftingPlans; // select random plan from array
private _boolean = [true,_plan,1] call life_fnc_handleInv; // add plan to inventory as usable item
if (_boolean) then { // if inventory wasn't full
    [3] call SOCK_fnc_updatePartial; // save to server
	[_plan] spawn { // spawn function so that we can use sleep inside
		params [
			["_plan","",[""]]
		];
		sleep 1; // wait one second
		private _rarityVarname = getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _plan >> "rarity"); // get varname of rarity
		private _rarityDisplayName = [getText(missionConfigFile >> "Cation_CraftingV2" >> "rarities" >> _rarityVarname >> "displayName")] call cat_craftingV2_fnc_getText; // get displayname of rarity
		hint parseText format ["<img size='5' image='%4'/><br/><br/>[%1] %2 %3<br/>",_rarityDisplayName,localize getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _plan >> "displayName"), ["Found"] call cat_craftingV2_fnc_getText, getText(missionConfigFile >> "Cation_CraftingV2" >> "plans" >> _plan >> "icon")]; // show notifiaction that player found plan
	};
};