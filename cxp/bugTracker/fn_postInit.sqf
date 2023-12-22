/*
	Author: Casperento
	
	Description:
	Initializes the main bugtracker functions

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Überprüft, ob keine Benutzeroberfläche vorhanden ist, und beendet den Code, wenn dies der Fall ist
if (!hasInterface) exitWith {};

// Initialisiert den Timer für den Bugtracker auf 0
cxp_bt_timer = 0;

// Überprüft die Konfiguration für das Öffnen des Bugtrackers mit einer Taste
if ((getNumber(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_keyOpenOn")) isEqualTo 1) then {
    // Erstellt einen Spawn-Block für asynchrone Ausführung
	[] spawn {
        // Wartet, bis das Display mit der ID 46 nicht mehr vorhanden ist
		waitUntil {!(isNull (findDisplay 46))};
		
        // Fügt einen Event-Handler für die Tasteneingabe hinzu
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call {
			if ((_this select 1) isEqualTo (getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_keyOpen"")) && !dialog && !visibleMap && !(player getVariable [""restrained"",false]) && !(animationState player isEqualTo ""Incapacitated"")) then {
				if (call compile getText(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_reportFailed"")) exitWith {
					hint (["STR_CXP_BT_Hint_ReportFailed""] call cxp_utils_fnc_getRealText);
				};
				if (cxp_bt_timer != 0 && (time - cxp_bt_timer) < (60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay""))) exitWith {
					hint format[(["STR_CXP_BT_Hint_DelayTimer""] call cxp_utils_fnc_getRealText),([((60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay"")) - (time - cxp_bt_timer)),""MM:SS""] call BIS_fnc_secondsToString)];
				};
				call cxpbt_fnc_buildMenu;
				true;
			};
		}"];
	};
} else {
    // Falls die Konfiguration für die Taste nicht aktiviert ist, wird eine Funktion zum manuellen Öffnen erstellt
	cxpbt_fnc_btnBugTracker = compileFinal "
		if (call compile getText(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_reportFailed"")) exitWith {
			hint (["STR_CXP_BT_Hint_ReportFailed""] call cxp_utils_fnc_getRealText);
		};
		if (cxp_bt_timer != 0 && (time - cxp_bt_timer) < (60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay""))) exitWith {
			hint format[(["STR_CXP_BT_Hint_DelayTimer""] call cxp_utils_fnc_getRealText),([((60 * getNumber(missionConfigFile >> ""Cxp_Config_BugTracker"" >> ""cxp_bt_delay"")) - (time - cxp_bt_timer)),""MM:SS""] call BIS_fnc_secondsToString)];
		};
		call cxpbt_fnc_buildMenu;
	";
};
