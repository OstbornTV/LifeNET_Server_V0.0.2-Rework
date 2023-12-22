#include "\life_hc\hc_macros.hpp"

/*
    File: fn_vehicleUpdate.sqf
    Author: NiiRoZz
    Description:
    Tells the database that this vehicle need update inventory.
*/

params [
    ["_vehicle", objNull, [objNull]],  // Das betroffene Fahrzeug (Standardwert: objNull)
    ["_mode", 1, [0]]                   // Der Modus für die Aktualisierung (Standardwert: 1)
];

if (isNull _vehicle) exitWith {};  // Beende das Skript, wenn das Fahrzeug null ist (ungültiger Parameter).

private _dbInfo = _vehicle getVariable ["dbInfo",[]];  // Fahrzeuginformationen aus der Datenbank
if (_dbInfo isEqualTo []) exitWith {};  // Beende das Skript, wenn die Fahrzeuginformationen leer sind (ungültiges Fahrzeug).

private _uid = _dbInfo select 0;  // UID des Fahrzeugbesitzers
private _plate = _dbInfo select 1;  // Kennzeichen des Fahrzeugs

switch (_mode) do {
    case 1: {
        // Modus 1: Aktualisierung des Fahrzeuginventars
        private _vehItems = getItemCargo _vehicle;
        private _vehMags = getMagazineCargo _vehicle;
        private _vehWeapons = getWeaponCargo _vehicle;
        private _vehBackpacks = getBackpackCargo _vehicle;
        private _cargo = [_vehItems,_vehMags,_vehWeapons,_vehBackpacks];

        // Halte es sauber!
        if (((_vehItems select 0) isEqualTo []) && ((_vehMags select 0) isEqualTo []) && ((_vehWeapons select 0) isEqualTo []) && ((_vehBackpacks select 0) isEqualTo [])) {
            _cargo = [];
        };

        private _query = format ["updateVehicleGear:%1:%2:%3", _cargo, _uid, _plate];
        private _thread = [_query, 1] call HC_fnc_asyncCall;  // Asynchrone Datenbankanfrage starten
    };

    case 2: {
        // Modus 2: Aktualisierung des Fahrzeugkofferraums
        private _resourceItems = LIFE_SETTINGS(getArray,"save_vehicle_items");
        private _trunk = _vehicle getVariable ["Trunk",[[],0]];
        private _itemList = _trunk select 0;
        private _totalweight = 0;
        private _items = [];
        {
            if ((_x select 0) in _resourceItems) then {
                _items pushBack [_x select 0,_x select 1];
                private _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
        } forEach _itemList;
        _trunk = [_items,_totalweight];

        private _query = format ["updateVehicleTrunk:%1:%2:%3", _trunk, _uid, _plate];
        private _thread = [_query,1] call HC_fnc_asyncCall;  // Asynchrone Datenbankanfrage starten
    };
};
