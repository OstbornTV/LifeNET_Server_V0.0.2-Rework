#include "..\..\script_macros.hpp"
/*
    File: fn_repairDoor.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Re-locks the door mainly for the federal reserve structures.
*/

// Überprüfen, ob das Gebäude ungültig ist
params [
    ["_building", objNull, [objNull]]
];

if (isNull _building) exitWith {};
if !(_building isKindOf "House_F") exitWith {
    hint localize "STR_ISTR_Bolt_NotNear";
};

// Holen Sie sich die Anzahl der Türen im Gebäude
private _doors = FETCH_CONFIG2(getNumber, "CfgVehicles", (typeOf _building), "NumberOfDoors");
private _door = 0;

// Finden Sie die nächste Tür
for "_i" from 1 to _doors do {
    private _selPos = _building selectionPosition format ["Door_%1_trigger", _i];
    private _worldSpace = _building modelToWorld _selPos;
    if (player distance _worldSpace < 5) exitWith {
        _door = _i;
    };
};

// Wenn keine Tür in der Nähe ist, brechen Sie ab
if (_door isEqualTo 0) exitWith {
    hint localize "STR_Cop_NotaDoor"
};

// Wenn die Tür bereits gesperrt ist, brechen Sie ab
private _doorN = _building getVariable [format ["bis_disabled_Door_%1", _door], 0];
if (_doorN isEqualTo 1) exitWith {
    hint localize "STR_House_FedDoor_Locked"
};

// Setzen Sie die Variable für die laufende Aktion
life_action_inUse = true;

// Schließen Sie das Dialogfeld
closeDialog 0;

// Fortschrittsbalken initialisieren
disableSerialization;
private _title = localize "STR_Cop_RepairingDoor";
"progressBar" cutRsc ["life_progress", "PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progressBar = _ui displayCtrl 38201;
private _titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
private _cP = 0.01;

// Berechnen Sie die Fortschrittsrate basierend auf dem Gebäudetyp
private _cpRate = switch (typeOf _building) do {
    case "Land_Dome_Big_F": {0.008};
    case "Land_Medevac_house_V1_F";
    case "Land_Research_house_V1_F": {0.005};
    default {0.08};
};

// Schleife für die Fortschrittsanzeige
for "_i" from 0 to 1 step 0 do {
    // Überprüfen Sie die Animation des Spielers
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };
    uiSleep 0.26;

    // Fortschrittsbalken aktualisieren
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress", "PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
    };
    _cP = _cP + _cpRate;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _title];

    // Überprüfen Sie die Abbruchbedingungen
    if (_cP >= 1 || {!alive player}) exitWith {};
    if (life_interrupted) exitWith {};
};

// UI entfernen und verschiedene Zustände überprüfen
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";
life_action_inUse = false;

// Wenn der Spieler nicht mehr lebt, brechen Sie ab
if (!alive player) exitWith {};

// Wenn die Aktion unterbrochen wurde, eine Meldung anzeigen
if (life_interrupted) exitWith {
    life_interrupted = false;
    titleText[localize "STR_NOTF_ActionCancel", "PLAIN"];
};

// Tür verriegeln und den gesamten Status überprüfen
_building animateSource [format ["Door_%1_source", _door], 0];
_building setVariable [format ["bis_disabled_Door_%1", _door], 1, true]; // Tür verriegeln

private _locked = true;
for "_i" from 1 to _doors do {
    if (_building getVariable [format ["bis_disabled_Door_%1", _i], 0] isEqualTo 0) exitWith {
        _locked = false
    };
};

// Wenn alle Türen verriegelt sind, das Gebäude als gesperrt markieren
if (_locked) then {
    _building setVariable ["locked", true, true];
};
