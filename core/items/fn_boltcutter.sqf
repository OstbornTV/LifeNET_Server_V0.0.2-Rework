#include "..\..\script_macros.hpp"
/*
    File: fn_boltcutter.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Breaks the lock on a single door (Closet door to the player).
*/

// Parametrisiere das Gebäude, die Türen und den Handle
private ["_building", "_door", "_doors", "_cpRate", "_title", "_progressBar", "_titleText", "_cp", "_ui"];
_building = param [0, objNull, [objNull]];

// Definiere die Position des Tresorraums und WL_Rosche
private _vaultHouse = [[["WL_Rosche", "Land_Research_house_V1_F"]]] call life_util_fnc_terrainSort;
private _wl_roscheArray = [16019.5, 16952.9, 0];
private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

// Überprüfe, ob das Gebäude existiert
if (isNull _building) exitWith {};
if (!(_building isKindOf "House_F")) exitWith { hint localize "STR_ISTR_Bolt_NotNear"; };

// Überprüfe, ob genügend Polizisten anwesend sind, wenn es sich um einen speziellen Raum handelt
if (((nearestObject [_pos, "Land_Dome_Big_F"]) == _building || (nearestObject [_pos, _vaultHouse]) == _building) && (west countSide playableUnits < (LIFE_SETTINGS(getNumber, "minimum_cops")))) exitWith {
    hint format [localize "STR_Civ_NotEnoughCops", (LIFE_SETTINGS(getNumber, "minimum_cops"))];
};

// Überprüfe, ob der Raum gesperrt ist, wenn es sich um einen speziellen Raum handelt
if ((typeOf _building) == _vaultHouse && (nearestObject [_pos, "Land_Dome_Big_F"]) getVariable ["locked", true]) exitWith { hint localize "STR_ISTR_Bolt_Exploit"; };

// Überprüfe, ob ein Limit für die Verwendung von Bolzenschneidern erreicht wurde
if (isNil "life_boltcutter_uses") then { life_boltcutter_uses = 0; };

// Initialisiere die Tür-Informationen
_doors = FETCH_CONFIG2(getNumber, "CfgVehicles", (typeOf _building), "numberOfDoors");
_door = 0;

// Suche die nächste Tür
for "_i" from 1 to _doors do {
    _selPos = _building selectionPosition format ["Door_%1_trigger", _i];
    _worldSpace = _building modelToWorld _selPos;
    if (player distance _worldSpace < 2) exitWith { _door = _i; };
};

// Wenn keine Tür in der Nähe ist, beende die Aktion
if (_door isEqualTo 0) exitWith { hint localize "STR_Cop_NotaDoor"; };

// Überprüfe, ob die Tür bereits entsperrt ist
if ((_building getVariable [format ["bis_disabled_Door_%1", _door], 0]) isEqualTo 0) exitWith { hint localize "STR_House_Raid_DoorUnlocked"; };

// Sende eine Broadcast-Nachricht, basierend auf dem Typ des Raums
if ((nearestObject [_pos, "Land_Dome_Big_F"]) == _building || (nearestObject [_pos, _vaultHouse]) == _building) then {
    [[1, 2], "STR_ISTR_Bolt_AlertFed", true, []] remoteExecCall ["life_fnc_broadcast", RCLIENT];
} else {
    [0, "STR_ISTR_Bolt_AlertHouse", true, [profileName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
    if (_building getVariable ["security", false]) then {
        if (!(isNil {(_building getVariable "house_owner")})) then {
            private "_owner";
            _owner = objNull;
            {
                if (((_building getVariable "house_owner") select 0) isEqualTo (getPlayerUID _x)) then {
                    _owner = _x;
                };
            } forEach playableUnits;
            [_building] remoteExec ["cat_alarm_fnc_houseAlarm", _owner];
        };
    };
};

// Setze die Flagge für die laufende Aktion
life_action_inUse = true;

// Setup Fortschrittsbalken
disableSerialization;
_title = localize "STR_ISTR_Bolt_Process";
"progressBar" cutRsc ["life_progress", "PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
_cp = 0.01;

// Setze die Geschwindigkeitsrate basierend auf dem Typ des Raums
switch (typeOf _building) do {
    case "Land_Dome_Big_F": { _cpRate = 0.003; };
    case "Land_Medevac_house_V1_F";
    case "Land_Research_house_V1_F": { _cpRate = 0.0015; };
    default { _cpRate = 0.08; };
};

// Iteriere durch den Fortschrittsbalken
for "_i" from 0 to 1 step 0 do {
    // Synchronisiere die Animation des Spielers, wenn nicht bereits geschehen
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    // Aktualisiere den Fortschrittsbalken und die Textanzeige
    uiSleep 0.26;
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress", "PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cp = _cp + _cpRate;
    _progressBar progressSetPosition _cp;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cp * 100), "%", _title];

    // Beende die Schleife, wenn der Fortschrittsbalken voll ist oder der Spieler nicht mehr lebt
    if (_cp >= 1 || !alive player) exitWith {};
    if (life_istazed) exitWith {}; // Tazed
    if (life_isknocked) exitWith {}; // Knocked
    if (life_interrupted) exitWith {};
};

// Beende den Fortschrittsbalken und überprüfe verschiedene Zustände
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";
if (!alive player || life_istazed || life_isknocked) exitWith { life_action_inUse = false; };
if (player getVariable ["restrained", false]) exitWith { life_action_inUse = false; };
if (life_interrupted) exitWith { life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_action_inUse = false; };

// Aktualisiere die Anzahl der Verwendungen von Bolzenschneidern
life_boltcutter_uses = life_boltcutter_uses + 1;
life_action_inUse = false;

// Überprüfe, ob das Limit für die Verwendung von Bolzenschneidern erreicht wurde
if (life_boltcutter_uses >= 5) then {
    [false, "boltcutter", 1] call life_fnc_handleInv;
    life_boltcutter_uses = 0;
};

// Entsperre die Tür und setze den Status auf nicht gesperrt
_building setVariable [format ["bis_disabled_Door_%1", _door], 0, true];
_building setVariable ["locked", false, true];

// Füge den Spieler der Wanted-Liste hinzu
if (life_HC_isActive) then {
    [getPlayerUID player, profileName, "459"] remoteExecCall ["HC_fnc_wantedAdd", HC_Life];
} else {
    [getPlayerUID player, profileName, "459"] remoteExecCall ["life_fnc_wantedAdd", RSERV];
};
