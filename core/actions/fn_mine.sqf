#include "..\..\script_macros.hpp"
/*
    File: fn_mine.sqf
    Author: Devilfloh
    Editor: Dardo

    Description:
    Same as fn_gather, but it allows the use of probabilities for mining.
*/

scopeName "main";

// Überprüfe, ob die Aktion bereits verwendet wird
if (life_action_inUse) exitWith {};
// Überprüfe, ob der Spieler in einem Fahrzeug ist
if !(isNull objectParent player) exitWith {};
// Überprüfe, ob der Spieler gefesselt ist
if (player getVariable "restrained") exitWith {
    hint localize "STR_NOTF_isrestrained";
};

// Überprüfe, ob der Spieler kapituliert hat
if (player getVariable "playerSurrender") exitWith {
    hint localize "STR_NOTF_surrender";
};

// Setze die Aktion als in Benutzung
life_action_inUse = true;

private _zone = "";
private _requiredItem = "";

// Holen Sie die Konfiguration für Mineralien
_resourceCfg = missionConfigFile >> "CfgGather" >> "Minerals";
_percent = (floor random 100) + 1; // Stelle sicher, dass es nicht 0 ist

private "_curConfig";
private "_resource";
private "_resources";
private "_maxGather";
private "_zoneSize";
private "_resourceZones";
private "_mined";

// Iteriere durch die Konfiguration der Mineralien
for "_i" from 0 to count(_resourceCfg) - 1 do {
    _curConfig = _resourceCfg select _i;
    _resources = getArray(_curConfig >> "mined");
    _maxGather = getNumber(_curConfig >> "amount");
    _zoneSize = getNumber(_curConfig >> "zoneSize");
    _resourceZones = getArray(_curConfig >> "zones");
    _requiredItem = getText(_curConfig >> "item");
    _mined = "";

    // Beende, wenn keine Ressourcen vorhanden sind
    if (_resources isEqualTo []) exitWith {};

    // Iteriere durch die Ressourcen
    for "_i" from 0 to count _resources do {
        // Wenn es nur eine Ressource gibt
        if (count _resources isEqualTo 1) exitWith {
            // Überprüfe, ob die Ressource ein Array ist
            if (!((_resources select 0) isEqualType [])) then {
                _mined = _resources select 0;
            } else {
                _mined = (_resources select 0) select 0;
            };
        };
        // Holen Sie die Ressource und ihre Wahrscheinlichkeiten
        _resource = (_resources select _i) select 0;
        _prob = (_resources select _i) select 1;
        _probdiff = (_resources select _i) select 2;
        // Überprüfe, ob die Wahrscheinlichkeit im gültigen Bereich liegt
        if ((_percent >= _prob) && (_percent <= _probdiff)) exitWith {
            _mined = _resource;
        };
    };

    // Iteriere durch die Ressourcenzonen
    {
        if ((player distance(getMarkerPos _x)) < _zoneSize) exitWith {
            _zone = _x;
        };
    } forEach _resourceZones;

    // Beende, wenn eine Zone gefunden wurde
    if (_zone != "") exitWith {};
};

// Beende, wenn keine Zone gefunden wurde
if (_zone isEqualTo "") exitWith {
    life_action_inUse = false;
};

// Überprüfe, ob ein erforderliches Element angegeben ist
if (_requiredItem != "") then {
    _valItem = missionNamespace getVariable ("life_inv_" + _requiredItem);

    // Beende, wenn der Spieler nicht über das erforderliche Element verfügt
    if (_valItem < 1) exitWith {
        switch (_requiredItem) do {
            case "pickaxe": {
                titleText[(localize "STR_NOTF_Pickaxe"), "PLAIN"];
            };
        };
        life_action_inUse = false;
        breakOut "main";
    };
};

// Berechne die Menge und Differenz
private _amount = round(random(_maxGather)) + 1;
private _diff = [_mined, _amount, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;

// Beende, wenn die Differenz 0 ist
if (_diff isEqualTo 0) exitWith {
    hint localize "STR_NOTF_InvFull";
    life_action_inUse = false;
};

// Sende eine Benachrichtigung über die Mining-Aktion
[player, "mining", 35, 1] remoteExecCall ["life_fnc_say3D", RCLIENT];

// Spiele die Aktionen für das Mining ab
for "_i" from 0 to 4 do {
    player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    waitUntil {
        animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    };
    sleep 0.5;
};

// Überprüfe, ob die Inventarbearbeitung erfolgreich war
if (([true, _mined, _diff] call life_fnc_handleInv)) then {
    _itemName = M_CONFIG(getText, "VirtualItems", _mined, "displayName");
    titleText[format [localize "STR_NOTF_Mine_Success", _itemName, _diff], "PLAIN"];
};

// Warte kurz und setze die Aktion als nicht in Benutzung
sleep 2.5;
life_action_inUse = false;
