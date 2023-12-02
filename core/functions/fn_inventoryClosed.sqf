#include "..\..\script_macros.hpp"
/*
    File: fn_inventoryClosed.sqf
    Author: Bryan "Tonic" Boardwine
    Modified : NiiRoZz

    Description:
    1 : Wird verwendet, um die Daten des Hauscontainers zu synchronisieren. Wenn das Inventar geschlossen wird,
    wird eine Synchronisationsanforderung an den Server gesendet.
    2 : Wird verwendet, um das Fahrzeuginventar zu synchronisieren, wenn die Option zum Speichern des Fahrzeuginventars aktiviert ist.
*/
params [
    "", // Unbenutzter Parameter
    ["_container", objNull, [objNull]] // Optionaler Parameter für den Container (Standardwert: objNull)
];

// Überprüfe, ob der Container nicht null ist
if (isNull _container) exitWith {};

// Überprüfe, ob der Container ein bestimmter Typ ist (z.B. "Box_IND_Grenades_F" oder "B_supplyCrate_F")
if ((typeOf _container) in ["Box_IND_Grenades_F", "B_supplyCrate_F"]) exitWith {
    // Überprüfe, ob der Headless Client aktiv ist
    if (life_HC_isActive) then {
        // Sende eine Remote-Exec-Anforderung an den Headless Client, um die Hauscontainer-Daten zu aktualisieren
        [_container] remoteExecCall ["HC_fnc_updateHouseContainers", HC_Life];
    } else {
        // Sende eine Remote-Exec-Anforderung an den Server, um die Hauscontainer-Daten zu aktualisieren
        [_container] remoteExecCall ["TON_fnc_updateHouseContainers", RSERV];
    };

    // Sende eine Synchronisationsanforderung an den Server
    [3] call SOCK_fnc_updatePartial;
};

// Überprüfe, ob die Option zum Speichern des Fahrzeuginventars aktiviert ist
if (LIFE_SETTINGS(getNumber, "save_vehicle_inventory") isEqualTo 1) exitWith {
    // Überprüfe, ob der Container ein Fahrzeug ist (Auto, Luftfahrzeug oder Schiff)
    if (_container isKindOf "Car" || {_container isKindOf "Air"} || {_container isKindOf "Ship"}) then {
        // Überprüfe, ob der Headless Client aktiv ist
        if (life_HC_isActive) then {
            // Sende eine Remote-Exec-Anforderung an den Headless Client, um das Fahrzeuginventar zu aktualisieren
            [_container, 1] remoteExecCall ["HC_fnc_vehicleUpdate", HC_Life];
        } else {
            // Sende eine Remote-Exec-Anforderung an den Server, um das Fahrzeuginventar zu aktualisieren
            [_container, 1] remoteExecCall ["TON_fnc_vehicleUpdate", RSERV];
        };
    };

    // Sende eine Synchronisationsanforderung an den Server
    [3] call SOCK_fnc_updatePartial;
};
