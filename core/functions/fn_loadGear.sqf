#include "..\..\script_macros.hpp"
/*
    File: fn_loadGear.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Loads saved civilian gear, this is limited for a reason and that's balance.
*/

// Warten, bis das Display 46 (Arsenal) nicht mehr null ist
private _itemArray = life_gear;
waitUntil { !(isNull (findDisplay 46)) };

// Die Spieler-Ladung auf ein leeres Loadout setzen
player setUnitLoadout (configFile >> "EmptyLoadout");

// Wenn _itemArray leer ist, starte das Standard-Ladout
if (_itemArray isEqualTo []) exitWith { [] call life_fnc_startLoadout; };

// Parameter für die Ausrüstung
_itemArray params [
    "_uniform",
    "_vest",
    "_backpack",
    "_goggles",
    "_headgear",
    ["_items", []],
    "_prim",
    "_seco",
    ["_uItems", []],
    ["_uMags", []],
    ["_bItems", []],
    ["_bMags", []],
    ["_vItems", []],
    ["_vMags", []],
    ["_pItems", []],
    ["_hItems", []],
    ["_yItems", []]
];

private "_handle";

// Goggles, Headgear, Uniform, Vest und Backpack behandeln
{ if (!(_x isEqualTo "")) then { _handle = [_x, true, false, false, false] spawn life_fnc_handleItem; waitUntil { scriptDone _handle }; }; } forEach [_goggles, _headgear, _uniform, _vest, _backpack];

// Einzelposten behandeln
{ _handle = [_x, true, false, false, false] spawn life_fnc_handleItem; waitUntil { scriptDone _handle }; } forEach _items;

// Gegenstände zum Spieler hinzufügen (Uniform, Vest, Backpack)
{ player addItemToUniform _x; } forEach (_uItems);
{ (uniformContainer player) addItemCargoGlobal [_x, 1]; } forEach (_uMags);
{ player addItemToVest _x; } forEach (_vItems);
{ (vestContainer player) addItemCargoGlobal [_x, 1]; } forEach (_vMags);
{ player addItemToBackpack _x; } forEach (_bItems);
{ (backpackContainer player) addItemCargoGlobal [_x, 1]; } forEach (_bMags);

// Maximales Gewicht festlegen
life_maxWeight = if (backpack player isEqualTo "") then { LIFE_SETTINGS(getNumber, "total_maxWeight") } else { LIFE_SETTINGS(getNumber, "total_maxWeight") + round(FETCH_CONFIG2(getNumber, "CfgVehicles", (backpack player), "maximumload") / 4) };

// Inventar behandeln
{ [true, (_x select 0), (_x select 1)] call life_fnc_handleInv; } forEach (_yItems);

// Primär- und Sekundärwaffen (Handfeuerwaffe) zuletzt hinzufügen
{ if (!(_x isEqualTo "")) then { _handle = [_x, true, false, false, false] spawn life_fnc_handleItem; waitUntil { scriptDone _handle }; }; } forEach [_prim, _seco];

// Primär- und Sekundärwaffen-Items hinzufügen
{ if (!(_x isEqualTo "")) then { player addPrimaryWeaponItem _x; } } forEach (_pItems);
{ if (!(_x isEqualTo "")) then { player addHandgunItem _x; } } forEach (_hItems);

// Spieler-Skins aktualisieren
[] call life_fnc_playerSkins;
