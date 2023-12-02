#include "..\..\script_macros.hpp"
/*
    File: fn_dropItems.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Wird bei Tod aufgerufen. Der Spieler lässt alle 'virtuellen' Gegenstände fallen, die er tragen könnte.
*/

private ["_obj", "_unit", "_item", "_value", "_pos"];

_unit = _this select 0;

{
    if (_x isEqualType "") then {
        _item = _x;
    } else {
        _item = configName _x;
    }

    _value = ITEM_VALUE(_item);
    _itemName = ITEM_VARNAME(_item);

    // Gemeinsame Funktion zum Erstellen von Gegenständen
    private _createItem = {
        _pos = _unit modelToWorld [0, 3, 0];
        _pos = [_pos select 0, _pos select 1, 0];
        _obj = _x createVehicle _pos;
        [_obj] remoteExecCall ["life_fnc_simDisable", RANY];
        _obj setPos _pos;
        _obj setVariable ["item", [_item, _value], true];
        missionNamespace setVariable [_itemName, 0];
    };

    // Gegenstände auf Basis ihres Typs erstellen
    switch (_item) do {
        case "waterBottle", "tbacon", "redgull", "fuelEmpty", "fuelFull", "coffee": {
            if (_value > 0) then {
                _createItem ["Land_" + _item + "_V1_F"];
            };
        };

        case "life_cash": {
            if (CASH > 0) then {
                _createItem ["Land_Money_F"];
                _obj setVariable ["item", ["money", missionNamespace getVariable [_item, 0]], true];
                missionNamespace setVariable ["CASH", 0];
            };
        };

        default {
            if (_value > 0) then {
                _createItem ["Land_Suitcase_F"];
            };
        };
    };
} forEach (("true" configClasses (missionConfigFile >> "VirtualItems")) + ["life_cash"]);
