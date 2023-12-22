#include "\life_hc\hc_macros.hpp"

/*
    File: fn_vehicleStore.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Stores the vehicle in the 'Garage'
*/

params [
    ["_vehicle", objNull, [objNull]],   // Das zu speichernde Fahrzeug (Standardwert: objNull)
    ["_impound", false, [true]],         // Gibt an, ob das Fahrzeug in der Garage untergebracht wird (Standardwert: false)
    ["_unit", objNull, [objNull]],       // Die Einheit (Spieler), der das Fahrzeug gehört (Standardwert: objNull)
    ["_storetext", "", [""]]             // Text, der für die Speicheraktion verwendet wird (Standardwert: "")
];

private _resourceItems = LIFE_SETTINGS(getArray,"save_vehicle_items");  // Ressourcen-Items, die gespeichert werden sollen
private _ownerID = _unit getVariable ["life_clientID",-1];  // ID des Fahrzeugeigentümers

// Überprüfen auf ungültige Parameter
if (isNull _vehicle || {isNull _unit}) exitWith {
    life_impound_inuse = false;
    _ownerID publicVariableClient "life_impound_inuse";
    life_garage_store = false;
    _ownerID publicVariableClient "life_garage_store";
}; // Ungültige Daten übergeben.

private _vInfo = _vehicle getVariable ["dbInfo", []];  // Fahrzeuginformationen aus der Datenbank
private "_plate";
private "_uid";

if !(_vInfo isEqualTo []) then {
    _plate = _vInfo select 1;
    _uid = _vInfo select 0;
};

// Schaden speichern.
private "_damage";
if (LIFE_SETTINGS(getNumber,"save_vehicle_damage") isEqualTo 1) then {
    _damage = getAllHitPointsDamage _vehicle;
    _damage = _damage select 2;
} else {
    _damage = [];
};
// Wegen des Kraftstoffpreises!
private "_fuel";
if (LIFE_SETTINGS(getNumber,"save_vehicle_fuel") isEqualTo 1) then {
    _fuel = (fuel _vehicle);
} else {
    _fuel = 1;
};

private "_query";
private "_thread";

// Wenn das Fahrzeug in der Garage untergebracht werden soll
if (_impound) exitWith {
    if (_vInfo isEqualTo []) then  {
        life_impound_inuse = false;
        _ownerID publicVariableClient "life_impound_inuse";
        if (!isNil "_vehicle" && {!isNull _vehicle}) then {
            deleteVehicle _vehicle;
        };
    } else {    // Keine kostenlosen Reparaturen!
        _query = format ["updateVehicleFuel:%1:%2:%3:%4", _fuel, _damage, _uid, _plate];
        _thread = [_query,1] call HC_fnc_asyncCall;
        if (!isNil "_vehicle" && {!isNull _vehicle}) then {
            deleteVehicle _vehicle;
        };
        life_impound_inuse = false;
        _ownerID publicVariableClient "life_impound_inuse";
    };
};

// Wenn das Fahrzeug nicht persistent ist
if (_vInfo isEqualTo []) exitWith {
    if (LIFE_SETTINGS(getNumber,"vehicle_rentalReturn") isEqualTo 1) then {
        [1,"STR_Garage_Store_NotPersistent2",true] remoteExecCall ["life_fnc_broadcast",_ownerID];
        if (!isNil "_vehicle" && {!isNull _vehicle}) then {
            deleteVehicle _vehicle;
        };
    } else {
        [1,"STR_Garage_Store_NotPersistent",true] remoteExecCall ["life_fnc_broadcast",_ownerID];
    };
    life_garage_store = false;
    _ownerID publicVariableClient "life_garage_store";
};

// Wenn die UID des Fahrzeugeigentümers nicht mit der UID des Spielers übereinstimmt
if !(_uid isEqualTo getPlayerUID _unit) exitWith {
    [1,"STR_Garage_Store_NoOwnership",true] remoteExecCall ["life_fnc_broadcast",_ownerID];
    life_garage_store = false;
    _ownerID publicVariableClient "life_garage_store";
};

// Sortieren von whitelisteten Items!
private _trunk = _vehicle getVariable ["Trunk", [[], 0]];
private _itemList = _trunk select 0;
private _totalweight = 0;
private "_weight";
_items = [];
if (LIFE_SETTINGS(getNumber,"save_vehicle_virtualItems") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"save_vehicle_illegal") isEqualTo 1) then {
        private _blacklist = false;
        _profileQuery = format ["selectName:%1", _uid];
        _profileName = [_profileQuery, 2] call HC_fnc_asyncCall;
        _profileName = _profileName select 0;

        {
            private _isIllegal = M_CONFIG(getNumber,"VirtualItems",(_x select 0),"illegal");
            _isIllegal = if (_isIllegal isEqualTo 1) then { true } else { false };
            if (((_x select 0) in _resourceItems) || (_isIllegal)) then {
                _items pushBack[(_x select 0),(_x select 1)];
                _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
            if (_isIllegal) then {
                _blacklist = true;
            };
        }
        forEach _itemList;
        if (_blacklist) then {
            [_uid, _profileName, "481"] remoteExecCall["life_fnc_wantedAdd", RSERV];
            _query = format ["updateVehicleBlacklistPlate:%1:%2", _uid, _plate];
            _thread = [_query, 1] call HC_fnc_asyncCall;
        };
    }
    else {
        {
            if ((_x select 0) in _resourceItems) then {
                _items pushBack[(_x select 0),(_x select 1)];
                _weight = (ITEM_WEIGHT(_x select 0)) * (_x select 1);
                _totalweight = _weight + _totalweight;
            };
        }
        forEach _itemList;
    };

    _trunk = [_items, _totalweight];
}
else {
    _trunk = [[], 0];
};

private "_cargo";

if (LIFE_SETTINGS(getNumber,"save_vehicle_inventory") isEqualTo 1) then {
    private _vehItems = getItemCargo _vehicle;
    private _vehMags = getMagazineCargo _vehicle;
    private _vehWeapons = getWeaponCargo _vehicle;
    private _vehBackpacks = getBackpackCargo _vehicle;
    _cargo = [_vehItems, _vehMags, _vehWeapons, _vehBackpacks];
    // Keine Items? Leere das Array, damit die Datenbank hübsch aussieht
    if (((_vehItems select 0) isEqualTo []) && ((_vehMags select 0) isEqualTo []) && ((_vehWeapons select 0) isEqualTo []) && ((_vehBackpacks select 0) isEqualTo [])) then {_cargo = [];};
} else {
    _cargo = [];
};

// Update
_query = format ["updateVehicleAll:%1:%2:%3:%4:%5:%6", _trunk, _cargo, _fuel, _damage, _uid, _plate];
_thread = [_query,1] call HC_fnc_asyncCall;
if (!isNil "_vehicle" && {!isNull _vehicle}) then {
    deleteVehicle _vehicle;
};

life_garage_store = false;
_ownerID publicVariableClient "life_garage_store";
[1, _storetext] remoteExecCall ["life_fnc_broadcast", _ownerID];
