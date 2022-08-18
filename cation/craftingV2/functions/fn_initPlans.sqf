/*
    File: fn_initPlans.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Initializes crafting plans
*/
params [
	["_plans",[],[]]
];

{missionNamespace setVariable [(_x select 0),(_x select 1)];} forEach _plans; // set mission variable plan owned for each plan