/*
	Author: Casperento
	
	Description:
	Set task to reach processor/trader

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
cxpadg_taskDestination = player createSimpleTask ["adg_dest"];
cxpadg_taskDestination setTaskState "Created";
cxpadg_taskDestination setSimpleTaskDescription [
	(["STR_CXP_ADG_TaskStr_LongDescription"] call cxp_utils_fnc_getRealText),
	(["STR_CXP_ADG_TaskStr_ShortDescription"] call cxp_utils_fnc_getRealText),
	(["STR_CXP_ADG_TaskStr_SucceededDescription"] call cxp_utils_fnc_getRealText)
];
cxpadg_taskDestination setSimpleTaskDestination (getMarkerPos cxpadg_currMkName);
player setCurrentTask cxpadg_taskDestination;
cxpadg_taskDestination setTaskState "Assigned";
["Cxp_TaskAssigned_AdvGather"] call BIS_fnc_showNotification;

cxpadg_tggTask = createTrigger ["EmptyDetector", getMarkerPos cxpadg_currMkName, false];
cxpadg_tggTask setTriggerArea [10, 10, 0, false];
cxpadg_tggTask setTriggerActivation [str playerSide, "PRESENT", true];
cxpadg_tggTask setTriggerStatements [
	"this && (vehicle player) in thislist && local player",
	"
		cxpadg_taskDestination setTaskState 'Succeeded';
		call cxpadg_fnc_cancelTask;
	",
	""
];
