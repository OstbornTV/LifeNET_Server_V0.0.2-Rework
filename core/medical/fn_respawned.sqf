#include "..\..\script_macros.hpp"
/*
    File: fn_respawned.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sets the player up if he/she used the respawn option.
*/

// Reset player attributes and variables
private ["_containers"];
life_action_inUse = false;
life_use_atm = true;
life_hunger = 100;
life_thirst = 100;
life_carryWeight = 0;
CASH = 0; // Make sure we don't get our cash back.
life_respawned = false;
player playMove "AmovPercMstpSnonWnonDnon";

// Clear revive-related variables
life_corpse setVariable ["Revive", nil, true];
life_corpse setVariable ["name", nil, true];
life_corpse setVariable ["Reviving", nil, true];
player setVariable ["Revive", nil, true];
player setVariable ["name", nil, true];
player setVariable ["Reviving", nil, true];

// Reset player loadout
[] call life_fnc_startLoadout;

// Cleanup of weapon containers near the body & hide it.
if (!isNull life_corpse) then {
    _containers = nearestObjects[life_corpse, ["WeaponHolderSimulated"], 5];
    { deleteVehicle _x; } forEach _containers; // Delete the containers.
    deleteVehicle life_corpse;
}

// Destroy the death camera
life_deathCamera cameraEffect ["TERMINATE", "BACK"];
camDestroy life_deathCamera;

// Handle if player committed suicide in jail
if (life_is_arrested) exitWith {
    hint localize "STR_Jail_Suicide";
    life_is_arrested = false;
    [player, true] spawn life_fnc_jail;
    [] call SOCK_fnc_updateRequest;
};

// Handle if a cop didn't let EMS revive and gets rewarded half the bounty
if (!isNil "life_copRecieve") then {
    if (life_HC_isActive) then {
        [getPlayerUID player, player, life_copRecieve, true] remoteExecCall ["HC_fnc_wantedBounty", HC_Life];
    } else {
        [getPlayerUID player, player, life_copRecieve, true] remoteExecCall ["life_fnc_wantedBounty", RSERV];
    };
    life_copRecieve = nil;
}

// Handle if player was killed by a fellow gang member, cop, or themselves
if (life_removeWanted) then {
    if (life_HC_isActive) then {
        [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", HC_Life];
    } else {
        [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove", RSERV];
    };
}

// Update database and HUD
[] call SOCK_fnc_updateRequest;
[] call life_fnc_hudUpdate; // Request update of hud.
