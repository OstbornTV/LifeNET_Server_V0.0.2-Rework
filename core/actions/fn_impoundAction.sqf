#include "..\..\script_macros.hpp"
/*
    File: fn_impoundAction.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Impounds the vehicle
*/

params [
    ["_vehicle", objNull, [objNull]]
];

// Filter für erlaubte Fahrzeugtypen
private _filters = ["Car", "Air", "Ship"];

// Überprüfe, ob das Fahrzeug den erlaubten Typen entspricht
if !(KINDOF_ARRAY(_vehicle, _filters)) exitWith {};
// Überprüfe, ob der Spieler innerhalb einer akzeptablen Entfernung ist
if (player distance cursorObject > 10) exitWith {};
// Überprüfe, ob das Fahrzeug als NPC geschützt ist
if (_vehicle getVariable "NPC") exitWith { hint localize "STR_NPC_Protected" };

// Holen Sie die Fahrzeugdaten des Besitzers
private _vehicleData = _vehicle getVariable ["vehicle_info_owners", []];

// Beende, wenn keine Fahrzeugdaten vorhanden sind
if (_vehicleData isEqualTo []) exitWith { deleteVehicle _vehicle }; // Schlechtes Fahrzeug.

// Holen Sie den Anzeigenamen und den Preis des Fahrzeugs
private _vehicleName = FETCH_CONFIG2(getText, "CfgVehicles", (typeOf _vehicle), "displayName");
private _price = M_CONFIG(getNumber, "LifeCfgVehicles", (typeOf _vehicle), "price");

// Sende eine Rundfunknachricht über den Impound-Vorgang
[0, "STR_NOTF_BeingImpounded", true, [((_vehicleData select 0) select 1), _vehicleName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

// Setze die Aktion als in Benutzung
life_action_inUse = true;

// Zeige eine Fortschrittsleiste
disableSerialization;
"progressBar" cutRsc ["life_progress", "PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...", "%", localize "STR_NOTF_Impounding"];
_progress progressSetPosition 0.01;
private _cP = 0.01;

// Warte, während die Fortschrittsleiste läuft
for "_i" from 0 to 1 step 0 do {
    uiSleep 0.09;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", localize "STR_NOTF_Impounding"];
    if (_cP >= 1) exitWith {};
    // Beende, wenn der Spieler zu weit entfernt ist
    if (player distance _vehicle > 10) exitWith {};
    // Beende, wenn der Spieler nicht mehr lebt
    if (!alive player) exitWith {};
};

// Entferne die Fortschrittsleiste
"progressBar" cutText ["", "PLAIN"];

// Beende, wenn der Spieler zu weit entfernt ist
if (player distance _vehicle > 10) exitWith {
    hint localize "STR_NOTF_ImpoundingCancelled";
    life_action_inUse = false;
};

// Beende, wenn der Spieler nicht mehr lebt
if (!alive player) exitWith { life_action_inUse = false; };

// Überprüfe, ob das Fahrzeug keine Besatzung hat
if (crew _vehicle isEqualTo []) then {
    private _type = FETCH_CONFIG2(getText, "CfgVehicles", (typeOf _vehicle), "displayName");

    // Setze den Impound als in Benutzung
    life_impound_inuse = true;

    // Führe das Impound für das Fahrzeug durch
    if (life_HC_isActive) then {
        [_vehicle, true, player] remoteExec ["HC_fnc_vehicleStore", HC_Life];
    } else {
        [_vehicle, true, player] remoteExec ["TON_fnc_vehicleStore", RSERV];
    };

    // Warte, bis der Impound abgeschlossen ist
    waitUntil {!life_impound_inuse};

    // Überprüfe, ob der Spieler auf der Seite West ist
    if (playerSide isEqualTo west) then {
        // Multiplikator für den Fahrzeug-Impound
        private _impoundMultiplier = LIFE_SETTINGS(getNumber, "vehicle_cop_impound_multiplier");
        // Berechne den Wert des Fahrzeugs
        private _value = _price * _impoundMultiplier;

        // Sende eine Rundfunknachricht über das Impound
        [0, "STR_NOTF_HasImpounded", true, [profileName, ((_vehicleData select 0) select 1), _vehicleName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

        // Überprüfe, ob das Fahrzeug in der Fahrzeugliste vorhanden ist
        if (_vehicle in life_vehicles) then {
            // Zeige eine Meldung über das eigene Impound
            hint format [localize "STR_NOTF_OwnImpounded", [_value] call life_fnc_numberText, _type];
            BANK = BANK - _value;
        } else {
            // Zeige eine Meldung über ein fremdes Impound
            hint format [localize "STR_NOTF_Impounded", _type, [_value] call life_fnc_numberText];
            BANK = BANK + _value;
        };

        // Stelle sicher, dass die BANK nicht negativ wird
        if (BANK < 0) then { BANK = 0; };

        // Aktualisiere die BANK-Anzeige
        [1] call SOCK_fnc_updatePartial;
    };
} else {
    // Zeige eine Meldung, dass das Impound abgebrochen wurde
    hint localize "STR_NOTF_ImpoundingCancelled";
};

// Setze die Aktion als nicht in Benutzung
life_action_inUse = false;
