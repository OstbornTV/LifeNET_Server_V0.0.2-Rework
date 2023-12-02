#include "..\..\script_macros.hpp"
/*
    File: fn_clearAllVehicleAmmo.sqf
    Author: Dein Name

    Description:
    Entfernt alle Munition aus einem Fahrzeug.

    Syntax: _vehicle call life_fnc_clearAllVehicleAmmo;
*/
if !(hasInterface) exitWith {};  // Beendet das Skript, wenn es nicht lokal ausgeführt wird

life_fnc_clearAllVehicleAmmo = {
    params ["_vehicle"];

    if (isNull _vehicle) exitWith {};  // Beendet die Funktion, wenn das Fahrzeug null oder nicht vorhanden ist

    // Durchgehen aller Waffentürme des Fahrzeugs
    {
        private _turretPath = [_vehicle, _x] call BIS_fnc_turretPath;
        _vehicle removeMagazinesTurret [currentMagazineTurret _turretPath, _turretPath];
    } forEach (turrets _vehicle);

    clearweaponCargoGlobal _vehicle;  // Leert das Waffen-Cargo des Fahrzeugs global
    clearmagazineCargoGlobal _vehicle;  // Leert das Magazin-Cargo des Fahrzeugs global
    clearitemCargoGlobal _vehicle;  // Leert das Gegenstands-Cargo des Fahrzeugs global
    clearBackpackCargoGlobal _vehicle;  // Leert das Rucksack-Cargo des Fahrzeugs global
};

// Beispielaufruf:
// myVehicle call life_fnc_clearAllVehicleAmmo;
