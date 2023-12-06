#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleUpdate.sqf
    Author: NiiRoZz
    Description:
    Tells the database that this vehicle needs an inventory update.
*/

params [
    ["_vehicle", objNull, [objNull]],
    ["_mode", 1, [0]]
];

if (isNull _vehicle) exitWith {}; // NULL überprüfen

private _dbInfo = _vehicle getVariable ["dbInfo", []];
if (_dbInfo isEqualTo []) exitWith {};

private _uid = _dbInfo select 0;
private _plate = _dbInfo select 1;

switch (_mode) do {
    case 1: {
        // Modus 1: Aktualisiere das Inventar des Fahrzeugs
        private _vehItems = getItemCargo _vehicle;
        private _vehMags = getMagazineCargo _vehicle;
        private _vehWeapons = getWeaponCargo _vehicle;
        private _vehBackpacks = getBackpackCargo _vehicle;
        private _cargo = [_vehItems, _vehMags, _vehWeapons, _vehBackpacks];

        // Halte es sauber!
        if (((_vehItems select 0) isEqualTo []) && ((_vehMags select 0) isEqualTo []) && ((_vehWeapons select 0) isEqualTo []) && ((_vehBackpacks select 0) isEqualTo [])) then {
            _cargo = [];
        };

        private _query = format ["updateVehicleGear:%1:%2:%3", _cargo, _uid, _plate];
        private _thread = [_query, 1] call DB_fnc_asyncCall;
    };

    case 2: {
        // Modus 2: Aktualisiere den Kofferraum des Fahrzeugs
        private _resourceItems = LIFE_SETTINGS(getArray, "save_vehicle_items");
        private _trunk = _vehicle getVariable ["Trunk", [[], 0]];
        private _itemList = _trunk select 0;
        private _totalweight = 0;
        private _items = [];

        {
            if ((_x select 0) in _resourceItems) then {
                _items pushBack [(_x select 0), (_x select 1)];
                private _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
        } forEach _itemList;

        _trunk = [_items, _totalweight];
        _trunk = [_trunk] call DB_fnc_mresArray;

        private _query = format ["updateVehicleTrunk:%1:%2:%3", _trunk, _uid, _plate];
        private _thread = [_query, 1] call DB_fnc_asyncCall;
    };
};
