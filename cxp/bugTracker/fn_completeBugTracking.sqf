/*
	Author: Casperento
	
	Description:
	Complete bug report process

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [["_result", -1, [0]]];

(findDisplay -1) closeDisplay 1;
call compile (getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_saveFunction"));

if (_result isEqualTo 0) then {
	cxp_bt_timer = time;
	hint (["STR_CXP_BT_Hint_Thx"] call cxp_utils_fnc_getRealText);
} else {
	hint (["STR_CXP_BT_Hint_tryAgainLater"] call cxp_utils_fnc_getRealText);
};