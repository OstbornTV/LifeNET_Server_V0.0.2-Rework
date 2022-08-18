/*
    File: fn_showCrafting.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Displayes crafting items view of dialog
*/
disableSerialization;

private _display = findDisplay 5100; // get dialog
_display setVariable ["mode","items"];

// setup texts in dialog
(_display displayCtrl 5101) ctrlSetText format[["Title"] call cat_craftingV2_fnc_getText]; // set title
(_display displayCtrl 5102) ctrlSetText format[["Items"] call cat_craftingV2_fnc_getText]; // set item box title
(_display displayCtrl 5107) ctrlSetText format[["Plans"] call cat_craftingV2_fnc_getText]; // set plan box title

(_display displayCtrl 5107) buttonSetAction "[] call cat_craftingV2_fnc_showPlans"; // setup button action -> show plans

if (!life_is_processing) then { // if not processing
	(_display displayCtrl 5110) ctrlShow true; // show button	
	(_display displayCtrl 5110) ctrlSetText format [["Craft"] call cat_craftingV2_fnc_getText]; // set button text
	(_display displayCtrl 5113) ctrlShow true; // show item amount field
};

// setup combobox
private _combobox = _display displayCtrl 5106; // get dropdown
lbClear _combobox; // clear dropdown
private _station = _display getVariable ["station",""]; // get crafting station
{
	private _displayName = getText(missionConfigFile >> "Cation_CraftingV2" >> "categories" >> _x >> "displayName"); // get displayname
	_combobox lbAdd format[[_displayName] call cat_craftingV2_fnc_getText]; // add new entry
	_combobox lbSetData[(lbSize _combobox)-1,_x]; // set variablename of category to new entry
} forEach getArray(missionConfigFile >> "Cation_CraftingV2" >> "stations" >> _station >> "categories"); // all crafting categories of current station
if (lbSize _combobox isEqualTo 0) then { // no categories available
	_combobox lbAdd format[["NoCategories"] call cat_craftingV2_fnc_getText]; // set text no categories
	_combobox lbSetData[(lbSize _combobox)-1,"NoCategories"]; // set data no categories
};
_combobox lbSetCurSel 0; // select first category