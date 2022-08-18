#include "..\script_macros.hpp"
/*
    File: fn_initMedic.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initializes the medic..
*/

//waitUntil {!(isNull (findDisplay 46))};

diag_log "fn_initMedic.sqf";

if ((FETCH_CONST(life_medicLevel)) < 1 && (FETCH_CONST(life_adminlevel) isEqualTo 0)) exitWith {
    ["Notwhitelisted",false,true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht fÃ¼r diesen Slot whitelisted!","BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht fÃ¼r diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht fÃ¼r diesen Slot whitelisted!";
    sleep 35;
};

private _rank = FETCH_CONST(life_medicLevel);
private _paychecks = LIFE_SETTINGS(getArray,"paycheck_med");
if (count _paychecks isEqualTo 1) then {
    life_paycheck = _paychecks select 0;
} else {
    life_paycheck = _paychecks select _rank;
};
player setVariable ["rank", _rank, true];

//[] call life_fnc_placeablesInit;
[] call cat_spawn_fnc_spawnMenu;
waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.

private _standort = (text nearestLocation [ getPosATL player, "nameCity"]);
[name player,(getPlayerUID player),format["joint als MEDIC nahe %1",_standort],8] remoteExec ["TON_fnc_logIt",2];