/*
	Author: Casperento
	
	Description:
	Cancel current task

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
if (isNil "cxpmf_taskDestination") exitWith {};

if (taskState cxpmf_taskDestination isEqualTo "Assigned") then {
	["Cxp_TaskDestCanceled"] call BIS_fnc_showNotification;
} else {
	["Cxp_TaskDestSucceeded"] call BIS_fnc_showNotification;
};

player removeSimpleTask cxpmf_taskDestination;
cancelSimpleTaskDestination cxpmf_taskDestination;
cxpmf_taskDestination = nil;
deleteVehicle cxpmf_tggTask;
cxpmf_tggTask = nil;