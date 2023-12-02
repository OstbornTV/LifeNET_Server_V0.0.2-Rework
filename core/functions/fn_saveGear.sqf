#include "..\..\script_macros.hpp"
/*
    File: fn_saveGear.sqf
    Author: Bryan "Tonic" Boardwine
    Full Gear/Y-Menu Save by Vampire
    Edited: Itsyuka

    Description:
    Speichert die Ausrüstung des Spielers zur Synchronisierung mit der Datenbank für die Persistenz.
*/
private ["_return","_uItems","_bItems","_vItems","_pItems","_hItems","_yItems","_uMags","_vMags","_bMags","_pMag","_hMag","_uniform","_vest","_backpack","_verarbeitet","_gespeicherteVirtuelleItems"];
_return = [];
_gespeicherteVirtuelleItems = LIFE_SETTINGS(getArray,"saved_virtualItems");

// Grundlegende Informationen hinzufügen
_return pushBack uniform player;
_return pushBack vest player;
_return pushBack backpack player;
_return pushBack goggles player;
_return pushBack headgear player;
_return pushBack assignedItems player;

// Überprüfen, ob der Spieler Westen- oder Zivilistenseite ist und ob die Waffen gespeichert werden sollen
if (playerSide isEqualTo west || playerSide isEqualTo civilian && {LIFE_SETTINGS(getNumber,"save_civilian_weapons") isEqualTo 1}) then {
    _return pushBack primaryWeapon player;
    _return pushBack handgunWeapon player;
} else {
    _return pushBack "";
    _return pushBack "";
};

_uItems = [];
_uMags  = [];
_bItems = [];
_bMags  = [];
_vItems = [];
_vMags  = [];
_pItems = [];
_hItems = [];
_yItems = [];
_uniform = [];
_vest = [];
_backpack = [];

// Überprüfen und Verarbeiten der Ausrüstung im Uniform-Slot
if (!(uniform player isEqualTo "")) then {
    {
        if (_x in (magazines player)) then {
            _uMags pushBack _x;
        } else {
            _uItems pushBack _x;
        };
    } forEach (uniformItems player);
};

// Überprüfen und Verarbeiten der Ausrüstung im Rucksack-Slot
if (!(backpack player isEqualTo "")) then {
    {
        if (_x in (magazines player)) then {
            _bMags pushBack _x;
        } else {
            _bItems pushBack _x;
        };
    } forEach (backpackItems player);
};

// Überprüfen und Verarbeiten der Ausrüstung im Westen-Slot
if (!(vest player isEqualTo "")) then {
    {
        if (_x in (magazines player)) then {
            _vMags pushBack _x;
        } else {
            _vItems pushBack _x;
        };
    } forEach (vestItems player);
};

// Überprüfen und Verarbeiten der primären Waffenmagazine
if (count (primaryWeaponMagazine player) > 0 && alive player) then {
    _pMag = ((primaryWeaponMagazine player) select 0);

    if (!(_pMag isEqualTo "")) then {
        _uniform = player canAddItemToUniform _pMag;
        _vest = player canAddItemToVest _pMag;
        _backpack = player canAddItemToBackpack _pMag;
        _verarbeitet = false;

        if (_vest) then {
            _vMags pushBack _pMag;
            _verarbeitet = true;
        };

        if (_uniform && !_verarbeitet) then {
            _uMags pushBack _pMag;
            _verarbeitet = true;
        };

        if (_backpack && !_verarbeitet) then {
            _bMags pushBack _pMag;
            _verarbeitet = true;
        };
    };
};

// Überprüfen und Verarbeiten der Handwaffenmagazine
if (count (handgunMagazine player) > 0 && alive player) then {
    _hMag = ((handgunMagazine player) select 0);

    if (!(_hMag isEqualTo "")) then {
        _uniform = player canAddItemToUniform _hMag;
        _vest = player canAddItemToVest _hMag;
        _backpack = player canAddItemToBackpack _hMag;
        _verarbeitet = false;

        if (_vest) then {
            _vMags pushBack _hMag;
            _verarbeitet = true;
        };

        if (_uniform && !_verarbeitet) then {
            _uMags pushBack _hMag;
            _verarbeitet = true;
        };

        if (_backpack && !_verarbeitet) then {
            _bMags pushBack _hMag;
            _verarbeitet = true;
        };
    };
};

// Überprüfen und Verarbeiten der primären und Handwaffen-Items
if (count (primaryWeaponItems player) > 0) then {
    {
        _pItems pushBack _x;
    } forEach (primaryWeaponItems player);
};

if (count (handgunItems player) > 0) then {
    {
        _hItems pushBack _x;
    } forEach (handGunItems player);
};

// Überprüfen und Verarbeiten der virtuellen Items
{
    _wert = ITEM_VALUE(_x);
    if (_wert > 0) then {
        _yItems pushBack [_x,_wert];
    };
} forEach _gespeicherteVirtuelleItems;

// Hinzufügen der verarbeiteten Ausrüstung in die Rückgabe
_return pushBack _uItems;
_return pushBack _uMags;
_return pushBack _bItems;
_return pushBack _bMags;
_return pushBack _vItems;
_return pushBack _vMags;
_return pushBack _pItems;
_return pushBack _hItems;
if (LIFE_SETTINGS(getNumber,"save_virtualItems") isEqualTo 1) then {
    _return pushBack _yItems;
} else {
    _return pushBack [];
};

life_gear = _return;
