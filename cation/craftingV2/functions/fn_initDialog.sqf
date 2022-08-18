
/*
    File: fn_initDialog.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Creates dialog and calls main dialog functions
*/
params [
    ["_station","",[""]]
];
if (_station isEqualTo "") exitWith { // exit if no station variable name is passed
    if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
        diag_log "cationstudio crafting: [ERROR] Exit crafting because no crafting station was passed. Function cat_craftingV2_fnc_initDialog"; // log entry
    };
};

disableSerialization;

closeDialog 0; // close open dialogs
createDialog "CationCraftingMenu"; // open crafting menu

private _display = findDisplay 5100; // get dialog

_stations = ("true" configClasses (missionConfigFile >> "Cation_CraftingV2" >> "stations")); // get crafting stations

_display setVariable ["station",_station]; // set crafting station

[] call cat_craftingV2_fnc_updateLevelBar; // update level progress bar

// init dialog
[] call cat_craftingV2_fnc_showCrafting; // show crafting items view