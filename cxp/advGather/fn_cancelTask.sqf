/*
	Author: Casperento
	
	Description:
	Cancel current task

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
if (isNil "cxpadg_taskDestination") exitWith {};

if (taskState cxpadg_taskDestination isEqualTo "Assigned") then {
	["Cxp_TaskCanceled_AdvGather"] call BIS_fnc_showNotification;
} else {
	["Cxp_TaskSucceeded_AdvGather"] call BIS_fnc_showNotification;
};

player removeSimpleTask cxpadg_taskDestination;
cancelSimpleTaskDestination cxpadg_taskDestination;
cxpadg_taskDestination = nil;
deleteVehicle cxpadg_tggTask;
cxpadg_tggTask = nil;