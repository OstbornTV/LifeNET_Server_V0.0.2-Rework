/*
	Author: Casperento
	
	Description:
	Set task to reach processor/trader

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Erstelle eine einfache Aufgabe mit dem Namen "adg_dest"
cxpadg_taskDestination = player createSimpleTask ["adg_dest"];

// Setze den Aufgabenstatus auf "Created"
cxpadg_taskDestination setTaskState "Created";

// Setze die Beschreibung der einfachen Aufgabe
cxpadg_taskDestination setSimpleTaskDescription [
    (["STR_CXP_ADG_TaskStr_LongDescription"] call cxp_utils_fnc_getRealText),
    (["STR_CXP_ADG_TaskStr_ShortDescription"] call cxp_utils_fnc_getRealText),
    (["STR_CXP_ADG_TaskStr_SucceededDescription"] call cxp_utils_fnc_getRealText)
];

// Setze das Ziel der einfachen Aufgabe auf die Position des aktuellen Markers
cxpadg_taskDestination setSimpleTaskDestination (getMarkerPos cxpadg_currMkName);

// Setze die aktuelle Aufgabe des Spielers auf die erstellte Aufgabe
player setCurrentTask cxpadg_taskDestination;

// Setze den Aufgabenstatus auf "Assigned"
cxpadg_taskDestination setTaskState "Assigned";

// Zeige eine Benachrichtigung über die zugewiesene Aufgabe an
["Cxp_TaskAssigned_AdvGather"] call BIS_fnc_showNotification;

// Erstelle einen Trigger an der Position des aktuellen Markers
cxpadg_tggTask = createTrigger ["EmptyDetector", getMarkerPos cxpadg_currMkName, false];

// Setze die Trigger-Bereichsparameter
cxpadg_tggTask setTriggerArea [10, 10, 0, false];

// Setze die Trigger-Aktivierung auf die Anwesenheit des Spielers
cxpadg_tggTask setTriggerActivation [str playerSide, "PRESENT", true];

// Setze die Trigger-Statements, die beim Betreten des Triggers ausgeführt werden
cxpadg_tggTask setTriggerStatements [
    "this && (vehicle player) in thislist && local player",
    "
        cxpadg_taskDestination setTaskState 'Succeeded';
        call cxpadg_fnc_cancelTask;
    ",
    ""
];
