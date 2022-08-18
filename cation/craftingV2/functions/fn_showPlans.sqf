/*
    File: fn_showPlans.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Displayes crafting plans view of dialog
*/
disableSerialization;

private _display = findDisplay 5100; // get dialog
_display setVariable ["mode","plans"];

// setup texts in dialog
(_display displayCtrl 5102) ctrlSetText format[["Plans"] call cat_craftingV2_fnc_getText]; // set title
(_display displayCtrl 5107) ctrlSetText format[["Back"] call cat_craftingV2_fnc_getText]; // set button text

(_display displayCtrl 5107) buttonSetAction "[] call cat_craftingV2_fnc_showCrafting"; // setup button action -> go back to crafting

(_display displayCtrl 5110) ctrlShow false; // hide crafting button
(_display displayCtrl 5113) ctrlShow false; // hide crafting amount text field

// setup combobox
private _combobox = _display displayCtrl 5106; // get dropdown
lbClear _combobox; // clear dropdown
_combobox lbAdd format [["AllPlans"] call cat_craftingV2_fnc_getText]; // set category: all plans
_combobox lbAdd format [["OwnedPlans"] call cat_craftingV2_fnc_getText]; // set category: owned plans
_combobox lbAdd format [["LackedPlans"] call cat_craftingV2_fnc_getText]; // set category: lacked plans
_combobox lbSetCurSel 0; // select first category