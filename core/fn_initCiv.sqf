#include "..\script_macros.hpp"
/*
    File: fn_initCiv.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initializes the civilian.
*/
private _wl_roscheArray = [];
private _spawnBuildings = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

civ_spawn_1 = nearestObjects[getMarkerPos  "civ_spawn_rosch", _spawnBuildings,350];
civ_spawn_2 = nearestObjects[getMarkerPos  "civ_spawn_stock", _spawnBuildings,350];

waitUntil {!(isNull (findDisplay 46))};
life_paycheck = LIFE_SETTINGS(getNumber,"paycheck_civ");
if (life_is_alive && !life_is_arrested) then {
    /* Spawn at our last position */
    player setVehiclePosition [life_civ_position, [], 0, "CAN_COLLIDE"];
} else {
    if (!life_is_alive && !life_is_arrested) then {
        if (LIFE_SETTINGS(getNumber,"save_civilian_positionStrict") isEqualTo 1) then {
            [] call life_fnc_startLoadout;
            CASH = 0;
            [0] call SOCK_fnc_updatePartial;
        };
        [] call cat_spawn_fnc_spawnMenu;
        waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
        waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.
    } else {
        if (life_is_arrested) then {
            life_is_arrested = false;
            [player,true] spawn life_fnc_jail;
        };
    };
};
life_is_alive = true;