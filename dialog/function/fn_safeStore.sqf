#include "..\..\script_macros.hpp"
/*
    File: fn_safeStore.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Gateway copy of fn_vehStoreItem but designed for the safe.
*/

// Lokale Variablen deklarieren
private ["_ctrl", "_num"];

// Serialisierung deaktivieren
disableSerialization;

// Steuerelement und Nummer des Steuerelements abrufen
_ctrl = CONTROL_DATA(3503);
_num = ctrlText 3506;

// Fehlerüberprüfungen
if (!([_num] call life_util_fnc_isNumber)) exitWith { hint localize "STR_MISC_WrongNumFormat"; };
_num = parseNumber(_num);
if (_num < 1) exitWith { hint localize "STR_Cop_VaultUnder1"; };
if (!(_ctrl isEqualTo "goldBar")) exitWith { hint localize "STR_Cop_OnlyGold"; };
if (_num > life_inv_goldbar) exitWith { hint format [localize "STR_Cop_NotEnoughGold", _num]; };

// Element ins Safe legen
if (!([false, _ctrl, _num] call life_fnc_handleInv)) exitWith { hint localize "STR_Cop_CantRemove"; };

// Safe-Informationen aktualisieren
_safeInfo = life_safeObj getVariable ["safe", 0];
life_safeObj setVariable ["safe", _safeInfo + _num, true];

// Safe-Inventory aktualisieren
[life_safeObj] call life_fnc_safeInventory;
