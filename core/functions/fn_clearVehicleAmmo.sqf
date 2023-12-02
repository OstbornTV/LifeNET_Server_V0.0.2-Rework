#include "..\..\script_macros.hpp"
/*
    Datei: fn_clearvehicleammo.sqf
    Autor: Bryan "tonic" Boardwine

    Beschreibung:
    Entfernt die Munitionstypen, die nicht gewünscht sind, aus dem Fahrzeug.

    Syntax: _vehicle removeMagazinesTurret [Magazinname, Turmpfad]
    Dokumentation: https://community.bistudio.com/wiki/removeMagazinesTurret
*/
params [ ["_vehicle", objNull, [objNull]] ];

if (isNull _vehicle) exitWith {};  // Beendet das Skript, wenn das Fahrzeug null oder nicht vorhanden ist

private _veh = typeOf _vehicle;  // Erhält den Fahrzeugtyp

// Speedboat Minigun
if (_veh isEqualTo "B_Boat_Armed_01_minigun_F") then {
    _vehicle removeMagazinesTurret ["200Rnd_40mm_G_belt", [0]];
};
// AMV-7 Marshall
if (_veh isEqualTo "B_APC_Wheeled_01_cannon_F") then {
    _vehicle removeMagazinesTurret ["60Rnd_40mm_GPR_Tracer_Red_shells", [0]];
    _vehicle removeMagazinesTurret ["40Rnd_40mm_APFSDS_Tracer_Red_shells", [0]];
};
// Mi-48 Kajman (Schwarz)
if (_veh isEqualTo "O_Heli_Attack_02_black_F") then {
    _vehicle removeMagazinesTurret ["250Rnd_30mm_APDS_shells", [0]];
    _vehicle removeMagazinesTurret ["8Rnd_LG_scalpel", [0]];
    _vehicle removeMagazinesTurret ["38Rnd_80mm_rockets", [0]];
};
// UH-80 Ghost Hawk
if (_veh isEqualTo "B_Heli_Transport_01_F") then {
    _vehicle removeMagazinesTurret ["2000Rnd_65x39_Belt_Tracer_Red", [1]];
    _vehicle removeMagazinesTurret ["2000Rnd_65x39_Belt_Tracer_Red", [2]];
};

clearweaponCargoGlobal _vehicle;  // Leert das Waffen-Cargo des Fahrzeugs global
clearmagazineCargoGlobal _vehicle;  // Leert das Magazin-Cargo des Fahrzeugs global
clearitemCargoGlobal _vehicle;  // Leert das Gegenstands-Cargo des Fahrzeugs global
clearBackpackCargoGlobal _vehicle;  // Leert das Rucksack-Cargo des Fahrzeugs global
