/*
    File: fn_onProcessButtonClicked.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Called when craft button is pressed. Used to read some information from dialog and pass it to process function.
*/
disableSerialization;

if (life_is_processing) exitWith { // currently crafting
    hint format [["AlreadyInProcess"] call cat_craftingV2_fnc_getText]; // show notification
};

private _display = findDisplay 5100; // get dialog
private _listbox = _display displayCtrl 5105; // get item listbox
private _selectedIndex = lbCurSel _listbox; // get selection index
private _item = _listbox lbData _selectedIndex; // get item vehicleVarName
private _category = _display getVariable ["category",""];// get category
private _amount = parseNumber (ctrlText 5113);  // get item amount from text field
private _location = 0; // save to inventory - default option
private _parents = [(configfile >> "CfgVehicles" >> _item),true] call BIS_fnc_returnParents; // get parent classes
if (_amount < 1) exitWith { hint localize "STR_MISC_Under1"; };
if ("AllVehicles" in _parents) then { // if vehicle
    _location = 2; // set location variable to 2
} else {
    if !(("cat_locker_fnc_getText" call BIS_fnc_functionPath) isEqualTo "") then { // if locker system is installed
        private _locationChoice = [
            (["SelectStorage"] call cat_craftingV2_fnc_getText), // Text
            (["Title"] call cat_craftingV2_fnc_getText), // Heading
            (["Locker"] call cat_craftingV2_fnc_getText), // yes button
            (["Inventory"] call cat_craftingV2_fnc_getText) // no button
        ] call BIS_fnc_guiMessage;
        if (_locationChoice) then { // if yes clicked (LOCKER)
            _location = 1; // save to locker
            if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
                diag_log "cationstudio crafting: [INFO] Save crafted item to locker. Function cat_craftingV2_fnc_onProcessButtonClicked";
            };
        } else {
            if ((getNumber(missionConfigFile >> "Cation_CraftingV2" >> "DebugMode")) isEqualTo 1) then { // if debug mode is enabled
                diag_log "cationstudio crafting: [INFO] Save crafted item to player inventory. Function cat_craftingV2_fnc_onProcessButtonClicked";
            };
        };
    };
};
private _station = _display getVariable ["station",""]; // get station
[_item,_category,_amount,_location,_station] spawn cat_craftingV2_fnc_processItems; // start crafting process function