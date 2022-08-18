#include "\life_server\script_macros.hpp"
/*
	Author: Casperento
	
	Description:
	Save reported bug on database

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_rptrUID","",[""]],
	["_rptrName","",[""]],
	["_bugRptr","",[""]],
	["_exptdBeha","",[""]],
	["_unit",objNull,[objNull]]
];

if ((_rptrUID isEqualTo "") || (_rptrName isEqualTo "") || (_bugRptr isEqualTo "") || (_exptdBeha isEqualTo "")) exitWith {
	[] remoteExecCall ["cxpbt_fnc_completeBugTracking",owner _unit];
};

private _query = format["INSERT INTO bugTracker SET pid ='%1', name = '%2', bugReported = '%3', expectedBhv = '%4'",_rptrUID,_rptrName,_bugRptr,_exptdBeha];
call compile (getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_asyncFuntion"));

[0] remoteExecCall ["cxpbt_fnc_completeBugTracking",owner _unit];
