#include "..\..\script_macros.hpp"
/*
    File : removeContainer.sqf
    Author: NiiRoZz
    
    Description:
    Delete Container from house storage
*/

params [
    ["_container", objNull, [objNull]]
];

// Überprüfen, ob der Container ungültig ist
if (isNull _container) exitWith {};

// Holen Sie sich den Typ des Containers
private _containerType = typeOf _container;
// Holen Sie sich das nächstgelegene Haus zum Spieler
private _house = nearestObject [player, "House"];

// Überprüfen Sie, ob das Haus im Fahrzeug-Array enthalten ist
if !(_house in life_vehicles) exitWith {
    hint localize "STR_ISTR_Box_NotinHouse";
};

// Holen Sie sich die Container aus dem Haus
private _containers = _house getVariable ["containers", []];
// Schließen Sie das Dialogfeld
closeDialog 0;

// Dialogfeld für die Bestätigung des Containerlöschvorgangs anzeigen
private _action = [
    format [localize "STR_House_DeleteContainerMSG"], localize "STR_pInAct_RemoveContainer", localize "STR_Global_Remove", localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

// Überprüfen Sie die Benutzeraktion
if (_action) then {
    // Übersetzen Sie den Container-Typ in den entsprechenden Lagerkisten-Typ
    private _box = switch _containerType do {
        case "B_supplyCrate_F": {"storagebig"};
        case "Box_IND_Grenades_F": {"storagesmall"};
        default {"None"};
    };
    // Überprüfen Sie, ob der Container-Typ gültig ist
    if (_box isEqualTo "None") exitWith {};

    // Berechnen Sie die Gewichtsdifferenz
    private _diff = [_box, 1, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;
    // Überprüfen Sie, ob das Inventar voll ist
    if (_diff isEqualTo 0) exitWith { hint localize "STR_NOTF_InvFull"; };

    // Überprüfen Sie, ob der Headless Client aktiv ist
    if (life_HC_isActive) then {
        [_container] remoteExecCall ["HC_fnc_deleteDBContainer", HC_Life];
    } else {
        [_container] remoteExecCall ["TON_fnc_deleteDBContainer", RSERV];
    };

    // Durchlaufen Sie die Container im Haus und entfernen Sie den gelöschten Container
    {
        if (_x isEqualTo _container) then {
            _containers deleteAt _forEachIndex;
        };
    } forEach _containers;
    // Aktualisieren Sie die Containervariable im Haus
    _house setVariable ["containers", _containers, true];

    // Behandeln Sie das Hinzufügen des Containers zum Inventar
    [true, _box, 1] call life_fnc_handleInv;
};
