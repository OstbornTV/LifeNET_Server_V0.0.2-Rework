/*
    File: fn_handlePoints.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Handles crafting level up and down leveling.
*/
params [
	["_points",0,[0]],
	["_add",false,[false]]
];
if (_points < 1) exitWith {}; // check if points greater 0

private _oldPoints = missionNamespace getVariable ["cat_crafting_points",0]; // get old points

if (_add) then { // if add
	_points = _oldPoints + _points;
} else { // else sub
	_points = _oldPoints - _points;
	if (_points < 0) then { // if points lower 0
		_points = 0; // set points to 0
	};
};
missionNamespace setVariable ["cat_crafting_points",_points]; // update mission variable: points

if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
	diag_log format["cationstudio crafting: [INFO] points changed - new points: %1",_points]; // log entry
};

private _level = 0; // initialize level variable
{
	private _minPoints = getNumber(_x >> "minPoints"); // get min points required for current level
	if (_minPoints <= _points) then { // if min points lower or equal to current points
		_level = getNumber(_x >> "value"); // save level
	};
} forEach ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "levels")); // for each level config class
private _currentLevel = missionNamespace getVariable "cat_crafting_level"; // get current level
if !(_level isEqualTo _currentLevel) then { // level changed
	missionNamespace setVariable ["cat_crafting_level",_level]; // set new level
	if (_add) then { // if up rank
		if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
			diag_log format["cationstudio crafting: [INFO] level up - new level: %1",_level]; // log entry
		};
		hint format [["LevelUp"] call cat_craftingV2_fnc_getText,_level]; // show notification
	} else { // else down rank
		if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
			diag_log format["cationstudio crafting: [INFO] level down - new level: %1",_level]; // log entry
		};
		hint format [["LevelDown"] call cat_craftingV2_fnc_getText,_level]; // show notifiaction
	};
};

if (getNumber(missionConfigFile >> "Cation_CraftingV2" >> "HeadlessSupport") isEqualTo 0) then { // if headless client is not enabled
    [getPlayerUID player,_points,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePoints",2]; // call server
} else {
    if (life_HC_isActive) then { // if headless client is available
        [getPlayerUID player,_points,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePointsHC",HC_Life]; // call headless client
    } else { // else headless client unavailable
	    [getPlayerUID player,_points,playerSide] remoteExecCall ["cat_craftingV2_fnc_updatePoints",2]; // call server
    };
};

disableSerialization;

private _display = findDisplay 5100; // find dialog
if (!isNull _display) then { // if dialog is opened
	[] call cat_craftingV2_fnc_updateLevelBar; // update level progress bar
};