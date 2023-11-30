#include "..\..\script_macros.hpp"
/*
    File: fn_repairTruck.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Main functionality for toolkits, to be revised in a later version.
*/

// Holen Sie sich das aktuelle Fahrzeug unter dem Cursor des Spielers
private _veh = cursorObject;
// Initialisieren Sie die Variable für unterbrochene Aktionen
life_interrupted = false;

// Überprüfen Sie, ob das Fahrzeug ungültig ist
if (isNull _veh) exitWith {};
// Überprüfen Sie, ob es sich um ein Fahrzeug handelt (Auto, Schiff oder Flugzeug)
if ((_veh isKindOf "Car") || (_veh isKindOf "Ship") || (_veh isKindOf "Air")) then {
    // Überprüfen Sie, ob der Spieler ein Toolkit hat
    if (life_inv_toolkit > 0) then {
        // Setzen Sie die Variable für die aktuelle Aktion in den Verwendungszustand
        life_action_inUse = true;
        // Holen Sie sich den Anzeigenamen des Fahrzeugs aus der Konfiguration
        private _displayName = FETCH_CONFIG2(getText, "CfgVehicles", (typeOf _veh), "displayName");
        // Formatieren Sie die Fortschrittsanzeige
        private _upp = format [localize "STR_NOTF_Repairing", _displayName];

        // Fortschrittsbalken einrichten
        disableSerialization;
        "progressBar" cutRsc ["life_progress", "PLAIN"];
        private _ui = uiNamespace getVariable "life_progress";
        private _progress = _ui displayCtrl 38201;
        private _pgText = _ui displayCtrl 38202;
        _pgText ctrlSetText format ["%2 (1%1)...", "%", _upp];
        _progress progressSetPosition 0.01;
        private _cP = 0.01;

        // Schleife für die Fortschrittsanzeige
        for "_i" from 0 to 1 step 0 do {
            // Synchronisieren Sie die Animation des Spielers
            if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
                [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
                player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
                player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
            };

            // Warten Sie für die Fortschrittsanzeige
            uiSleep 0.27;
            _cP = _cP + 0.01;
            _progress progressSetPosition _cP;
            _pgText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _upp];

            // Überprüfen Sie die Abbruchbedingungen
            if (_cP >= 1) exitWith {};
            if (!alive player) exitWith {};
            if (!(isNull objectParent player)) exitWith {};
            if (life_interrupted) exitWith {};
        };

        // Setzen Sie die Variablen für die Fortschrittsanzeige zurück
        life_action_inUse = false;
        "progressBar" cutText ["", "PLAIN"];
        player playActionNow "stop";

        // Überprüfen Sie, ob die Aktion unterbrochen wurde
        if (life_interrupted) exitWith {
            life_interrupted = false;
            titleText[localize "STR_NOTF_ActionCancel", "PLAIN"];
            life_action_inUse = false;
        };

        // Überprüfen Sie, ob sich der Spieler in einem Fahrzeug befindet
        if (!(isNull objectParent player)) exitWith {
            titleText[localize "STR_NOTF_ActionInVehicle", "PLAIN"];
        };

        // Holen Sie sich die Einstellungen für die unendliche Reparatur je nach Fraktion
        private _sideRepairArray = LIFE_SETTINGS(getArray, "vehicle_infiniteRepair");

        // Überprüfen Sie, ob die Fraktion die unendliche Reparatur aktiviert hat
        call {
            if (playerSide isEqualTo civilian && (_sideRepairArray select 0) isEqualTo 0) exitWith {
                [false, "toolkit", 1] call life_fnc_handleInv;
            };
            if (playerSide isEqualTo west && (_sideRepairArray select 1) isEqualTo 0) exitWith {
                [false, "toolkit", 1] call life_fnc_handleInv;
            };
            if (playerSide isEqualTo independent && (_sideRepairArray select 2) isEqualTo 0) exitWith {
                [false, "toolkit", 1] call life_fnc_handleInv;
            };
            if (playerSide isEqualTo east && (_sideRepairArray select 3) isEqualTo 0) exitWith {
                [false, "toolkit", 1] call life_fnc_handleInv;
            };
        };

        // Reparieren Sie das Fahrzeug und aktualisieren Sie die Anzeige
        _veh setDamage 0;
        titleText[localize "STR_NOTF_RepairedVehicle", "PLAIN"];
    };
};
