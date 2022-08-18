/*
	Author: Casperento
	
	Description:
	Initializes the main bugtracker functions

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
if (!hasInterface) exitWith {};
cxp_bt_timer = 0;
if ((getNumber(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_keyOpenOn")) isEqualTo 1) then {
	[] spawn {
		waitUntil {!(isNull (findDisplay 46))};
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call {
			if ((_this select 1) isEqualTo (getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_keyOpen"")) && !dialog && !visibleMap && !(player getVariable [""restrained"",false]) && !(animationState player isEqualTo ""Incapacitated"")) then {
				if (call compile getText(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_reportFailed"")) exitWith {
					hint ([""STR_CXP_BT_Hint_ReportFailed""] call cxp_utils_fnc_getRealText);
				};
				if (cxp_bt_timer != 0 && (time - cxp_bt_timer) < (60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay""))) exitWith {
					hint format[([""STR_CXP_BT_Hint_DelayTimer""] call cxp_utils_fnc_getRealText),([((60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay"")) - (time - cxp_bt_timer)),""MM:SS""] call BIS_fnc_secondsToString)];
				};
				call cxpbt_fnc_buildMenu;
				true;
			};
		}"];
	};
} else {
	cxpbt_fnc_btnBugTracker = compileFinal "
		if (call compile getText(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_reportFailed"")) exitWith {
			hint ([""STR_CXP_BT_Hint_ReportFailed""] call cxp_utils_fnc_getRealText);
		};
		if (cxp_bt_timer != 0 && (time - cxp_bt_timer) < (60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay""))) exitWith {
			hint format[([""STR_CXP_BT_Hint_DelayTimer""] call cxp_utils_fnc_getRealText),([((60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay"")) - (time - cxp_bt_timer)),""MM:SS""] call BIS_fnc_secondsToString)];
		};
		call cxpbt_fnc_buildMenu;
	";
};
