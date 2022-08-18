/*
    File: fn_updateLevelBar.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Updates dialog level progress bar
*/
private _display = findDisplay 5100; // get dialog
private _points = missionNamespace getVariable ["cat_crafting_points",0]; // get player crafting points
private _minPoints = 0; // initialize min points variable
private _maxPoints = 0; // initialize max points variable
private _level = 0; // initialize level variable
private _levelName = ""; // initialize level name variable
{
	private _mP = getNumber(_x >> "minPoints"); // get min points
	if (_mP <= _points) then { // if min points lower or equal to player points
		_minPoints = _mp; // set minpoints
		_maxPoints = getNumber(_x >> "maxPoints"); // set max points
		_level = getNumber(_x >> "value"); // set level
		_levelName = getText(_x >> "displayName"); // set level name
	};
} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "levels")); // for each possible level
private _percentage = ((_points - _minPoints) / (_maxPoints - _minPoints)); // calculate percentage
(_display displayCtrl 5103) progressSetPosition _percentage; 
ctrlSetText[5104,format["%1 (%2) - %3%4",[_levelName] call cat_craftingV2_fnc_getText,_level,round(_percentage*100),"%"]];