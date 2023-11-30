#include "..\..\script_macros.hpp"
/*
    File: fn_storeVehicle.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Stores the vehicle in the garage.
*/
params [
    ["_garage", objNull, [objNull]],
    ["_unit", objNull, [objNull]]
];

private _vehicle = objNull;

// Überprüfen, ob der Spieler in einem Fahrzeug ist
if !(isNull objectParent player) then {
    _vehicle = vehicle player;
} else {
    // Fahrzeuge in der Nähe des Garagenobjekts abrufen
    private _nearVehicles = nearestObjects[getPos _garage,["Car","Air","Ship"],30];

    // Überprüfen, ob Fahrzeuge in der Nähe gefunden wurden
    if !(_nearVehicles isEqualTo []) then {
        {
            // Überprüfen, ob das Fahrzeug bereits gefunden wurde
            if (!isNull _vehicle) exitWith {};

            // Fahrzeugdaten abrufen
            private _vehData = _x getVariable ["vehicle_info_owners",[]];

            // Überprüfen, ob der Spieler der Eigentümer des Fahrzeugs ist
            if (count _vehData  > 0) then {
                private _vehOwner = ((_vehData select 0) select 0);
                if (getPlayerUID player isEqualTo _vehOwner) exitWith {
                    _vehicle = _x;
                };
            };
            true
        } count _nearVehicles;
    };
};

// Beenden, wenn kein Fahrzeug gefunden wurde
if (isNull _vehicle) exitWith {
    hint localize "STR_Garage_NoNPC";
};

// Beenden, wenn das Fahrzeug zerstört ist
if (!alive _vehicle) exitWith {
    hint localize "STR_Garage_SQLError_Destroyed";
};

// Erfolgsmeldung
private _storetext = localize "STR_Garage_Store_Success";

// Fahrzeug in der Garage speichern
if (life_HC_isActive) then {
    [_vehicle, false, _unit, _storetext] remoteExec ["HC_fnc_vehicleStore", HC_Life];
} else {
    [_vehicle, false, _unit, _storetext] remoteExec ["TON_fnc_vehicleStore", RSERV];
};

// Erfolgsmeldung
hint localize "STR_Garage_Store_Server";
life_garage_store = true;
