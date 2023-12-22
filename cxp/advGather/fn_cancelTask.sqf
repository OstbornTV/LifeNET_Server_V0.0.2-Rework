/*
	Author: Casperento
	
	Description:
	Cancel current task

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Überprüfe, ob die Variable cxpadg_taskDestination existiert
if (isNil "cxpadg_taskDestination") exitWith {};

// Überprüfe den Zustand der Aufgabe und zeige eine Benachrichtigung entsprechend an
if (taskState cxpadg_taskDestination isEqualTo "Assigned") then {
	["Cxp_TaskCanceled_AdvGather"] call BIS_fnc_showNotification;
} else {
	["Cxp_TaskSucceeded_AdvGather"] call BIS_fnc_showNotification;
}

// Entferne die einfache Aufgabe und storniere das Ziel
player removeSimpleTask cxpadg_taskDestination;
cancelSimpleTaskDestination cxpadg_taskDestination;

// Setze die Variable auf null und lösche das zugehörige Fahrzeug
cxpadg_taskDestination = nil;
deleteVehicle cxpadg_tggTask;
cxpadg_tggTask = nil;
