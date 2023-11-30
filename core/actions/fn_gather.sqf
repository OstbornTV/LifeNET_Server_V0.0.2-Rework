#include "..\..\script_macros.hpp"
/*
File: fn_gather.sqf
Author: Devilfloh

Description:
Main functionality for gathering.
*/
scopeName "main";

// Überprüfe, ob eine Aktion bereits in Verwendung ist
if (life_action_inUse) exitWith {};

// Überprüfe, ob der Spieler in einem Fahrzeug ist
if !(isNull objectParent player) exitWith {};

// Überprüfe, ob der Spieler gefesselt ist
if (player getVariable "restrained") exitWith {
    hint localize "str_notF_isrestrained";
};

// Überprüfe, ob der Spieler sich ergeben hat
if (player getVariable "playerSurrender") exitWith {
    hint localize "str_notF_surrender";
};

// Setze die Aktion als in Verwendung
life_action_inUse = true;

// Initialisiere Variablen
private _zone = "";
private _requiredItem = "";

// Konfiguration für Ressourcen
private _resourceCfg = missionConfigFile >> "CfgGather" >> "resources";

private "_curConfig";
private "_resource";
private "_maxGather";
private "_zonesize";
private "_resourceZones";

// Iteriere durch die Konfigurationen der Ressourcen
for "_i" from 0 to (count _resourceCfg) - 1 do {
    _curConfig = _resourceCfg select _i;
    _resource = configname _curConfig;
    _maxGather = getNumber(_curConfig >> "amount");
    _zonesize = getNumber(_curConfig >> "zonesize");
    _resourceZones = getArray(_curConfig >> "zones");
    _requiredItem = gettext(_curConfig >> "item");

    {
        // Überprüfe, ob der Spieler sich in der Nähe einer Ressourcenzone befindet
        if (_x isKindOf "Logic" && (player distance2D (getmarkerPos _x)) < _zonesize) exitWith {
            _zone = _x;
        };
        true
    } count _resourceZones;

    // Beende die Schleife, wenn eine gültige Ressourcenzone gefunden wurde
    if (isNull _zone) exitWith {};
};

// Beende, wenn keine gültige Ressourcenzone gefunden wurde
if (isNull _zone) exitWith {
    hint localize "str_notF_UnknownZone";
    life_action_inUse = false;
};

// Überprüfe, ob ein benötigtes Item vorhanden ist
if !(_requiredItem isEqualto "") then {
    private _valItem = missionnamespace getVariable [format["life_inv_%1", _requiredItem], 0];

    if (_valItem < 1) exitWith {
        switch (_requiredItem) do {
            // Hier könnten spezifische Meldungen für fehlende Items eingefügt werden
        };
        life_action_inUse = false;
        breakOut "main";
    };
};

// Generiere eine zufällige Menge an gesammelten Ressourcen
private _amount = round(random(_maxGather)) + 1;

// Berechne die Differenz in Gewicht
private _diff = [_resource, _amount, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;

// Beende, wenn das Inventar voll ist
if (_diff isEqualto 0) exitwith {
    hint localize "str_notF_invFull";
    life_action_inUse = false;
};

// Führe abhängig vom benötigten Item eine spezifische Aktion aus
switch (_requiredItem) do {
    case "pickaxe": {
        [player, "mining", 35, 1] remoteExecCall ["life_fnc_say3D", RCLIENT]
    };
    case "schaufel": {
        [player, "schaufeln", 35, 1] remoteExecCall ["life_fnc_say3D", RCLIENT]
    };
    default {
        [player, "harvest", 35, 1] remoteExecCall ["life_fnc_say3D", RCLIENT]
    };
};

// Spiele eine Animation für die Sammelaktion
for "_i" from 0 to 4 do {
    player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    waitUntil {
        animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    };
    sleep 0.5;
};

// Füge die gesammelten Ressourcen zum Inventar hinzu
if ([true, _resource, _diff] call life_fnc_handleinv) then {
    private _itemname = M_CONFIG(gettext, "Virtualitems", _resource, "displayname");
    titleText[format [localize "str_notF_Gather_Success", _itemname, _diff], "PLAin"];
    [20, 0, 1] call cat_craftingV2_fnc_randomPlan;
};

// Warte kurz und setze die Aktion als beendet
sleep 1;
life_action_inUse = false;
