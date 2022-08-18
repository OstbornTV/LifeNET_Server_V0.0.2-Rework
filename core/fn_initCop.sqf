#include "..\script_macros.hpp"
/*
    File: fn_initCop.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Cop Initialization file.
*/
//waitUntil {!(isNull (findDisplay 46))};

diag_log "fn_initCop.sqf";

if (life_blacklisted) exitWith {
    ["Blacklisted",false,true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!","BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!";
    sleep 30;
};

if ((FETCH_CONST(life_coplevel) < 1) && (FETCH_CONST(life_adminlevel) isEqualTo 0)) then {
    ["NotWhitelisted",false,true] call BIS_fnc_endMission;
    titleText ["**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!","BLACK"];
    hintC "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!"; 
    systemChat "**** ACHTUNG **** Du bist nicht für diesen Slot whitelisted!";
 sleep 35;
};

private _rank = FETCH_CONST(life_coplevel);
private _paychecks = LIFE_SETTINGS(getArray,"paycheck_cop");
if (count _paychecks isEqualTo 1) then {
    life_paycheck = _paychecks select 0;
} else {
    life_paycheck = _paychecks select _rank;
};
player setVariable ["rank", _rank, true];

//[] call life_fnc_placeablesInit;
[] call stig_sz_hideGUI;
[] call cat_spawn_fnc_spawnMenu;
waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.

private _standort = (text nearestLocation [ getPosATL player, "nameCity"]);
[name player,(getPlayerUID player),format["joint als COP nahe %1",_standort],8] remoteExec ["TON_fnc_logIt",2];