#include "..\..\script_macros.hpp"
/*
File: fn_clearvehicleammo.sqf
Author: Bryan "tonic" Boardwine

Description:
Clears the vehicle of ammo types that we don't want.

Syntax: _vehicle removeMagazinesTurret [magazinename, turretPath]
documentation: https:// community.bistudio.com/wiki/removeMagazinesTurret
*/
params [ ["_vehicle", objNull, [objNull]] ];

if (isNull _vehicle) exitwith {};

private _veh = typeOf _vehicle;

// speedboat minigun
if (_veh isEqualto "B_Boat_Armed_01_minigun_F") then {
    _vehicle removeMagazinesTurret ["200Rnd_40mm_G_belt", [0]];
};
// AMV-7 Marshall
if (_veh isEqualto "B_APC_Wheeled_01_cannon_F") then {
    _vehicle removeMagazinesTurret ["60Rnd_40mm_GPR_Tracer_Red_shells", [0]];
    _vehicle removeMagazinesTurret ["40Rnd_40mm_APFSDS_Tracer_Red_shells", [0]];
};
// Mi-48 Kajman (Black)
if (_veh isEqualto "O_Heli_Attack_02_black_F") then {
    _vehicle removeMagazinesTurret ["250Rnd_30mm_APDS_shells", [0]];
    _vehicle removeMagazinesTurret ["8Rnd_LG_scalpel", [0]];
    _vehicle removeMagazinesTurret ["38Rnd_80mm_rockets", [0]];
};
// UH-80 Ghost Hawk
if (_veh isEqualto "B_Heli_Transport_01_F") then {
    _vehicle removeMagazinesTurret ["2000Rnd_65x39_Belt_Tracer_Red", [1]];
    _vehicle removeMagazinesTurret ["2000Rnd_65x39_Belt_Tracer_Red", [2]];
};

clearweaponCargoGlobal _vehicle;
clearmagazineCargoGlobal _vehicle;
clearitemCargoGlobal _vehicle;
clearBackpackCargoGlobal _vehicle;