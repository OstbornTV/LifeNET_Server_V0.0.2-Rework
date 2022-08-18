/*
	Author: Casperento
	
	Description:
	Starts bug reporting process

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params ["_ctrl"];
private _display = ctrlParent _ctrl;

disableSerialization;
private _bugTxt = ctrlText (_display displayCtrl 7302);
private _behavTxt = ctrlText (_display displayCtrl 7301);

if ((_bugTxt isEqualTo "") || (_behavTxt isEqualTo "")) exitWith {
	closeDialog 0;
	hint (["STR_CXP_BT_Hint_emptyStr"] call cxp_utils_fnc_getRealText);
};

private _allowedChar = toArray(getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_allowedChar"));
private _allowedLen = getNumber(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_lenChar");

if (count(toArray(_bugTxt)) > _allowedLen || count(toArray(_behavTxt)) > _allowedLen) exitWith {
	hint format [(["STR_CXP_BT_Hint_CharLen"] call cxp_utils_fnc_getRealText), _allowedLen];
};

private _badCharBug = (toArray(_bugTxt)) findIf {!(_x in _allowedChar)} isEqualTo -1;
private _badCharBhv = (toArray(_behavTxt)) findIf {!(_x in _allowedChar)} isEqualTo -1;

if !(_badCharBug && _badCharBhv) exitWith {
	hint (["STR_CXP_BT_Hint_UnsuppChar"] call cxp_utils_fnc_getRealText);
};

private _playerName = profileName call cxp_utils_fnc_mresString;
_bugTxt = _bugTxt call cxp_utils_fnc_mresString;
_behavTxt = _behavTxt call cxp_utils_fnc_mresString;

[getPlayerUID player, _playerName, _bugTxt, _behavTxt, player] remoteExecCall ["cxpbt_fnc_saveBugReported",2];
