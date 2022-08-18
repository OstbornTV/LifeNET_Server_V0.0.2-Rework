#include "..\..\script_macros.hpp"
/*
File: fn_gather.sqf
Author: Devilfloh

Description:
Main functionality for gathering.
*/
scopeName "main";

if (life_action_inUse) exitwith {};
if !(isNull objectParent player) exitwith {};
if (player getVariable "restrained") exitwith {
    hint localize "str_notF_isrestrained";
};
if (player getVariable "playerSurrender") exitwith {
    hint localize "str_notF_surrender";
};

life_action_inUse = true;
private _zone = "";
private _requiredItem = "";

private _resourceCfg = missionConfigFile >> "CfgGather" >> "resources";

private "_curConfig";
private "_resource";
private "_maxGather";
private "_zonesize";
private "_resourceZones";

for "_i" from 0 to (count _resourceCfg)-1 do {
    _curConfig = _resourceCfg select _i;
    _resource = configname _curConfig;
    _maxGather = getNumber(_curConfig >> "amount");
    _zonesize = getNumber(_curConfig >> "zonesize");
    _resourceZones = getArray(_curConfig >> "zones");
    _requiredItem = gettext(_curConfig >> "item");
    
    {
        if ((player distance (getmarkerPos _x)) < _zonesize) exitwith {
            _zone = _x;
        };
        true
    } count _resourceZones;
    
    if !(_zone isEqualto "") exitwith {};
};

if (_zone isEqualto "") exitwith {
    life_action_inUse = false;
};

if !(_requiredItem isEqualto "") then {
    private _valItem = missionnamespace getVariable [format["life_inv_%1", _requiredItem], 0];
    
    if (_valItem < 1) exitwith {
        switch (_requiredItem) do {
        // Messages here
        };
        life_action_inUse = false;
        breakOut "main";
    };
};

private _amount = round(random(_maxGather)) + 1;
private _diff = [_resource, _amount, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;
if (_diff isEqualto 0) exitwith {
    hint localize "str_notF_invFull";
    life_action_inUse = false;
};

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

for "_i" from 0 to 4 do {
    player playMoveNow "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    waitUntil {
        animationState player != "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";
    };
    sleep 0.5;
};

if ([true, _resource, _diff] call life_fnc_handleinv) then {
    private _itemname = M_CONFIG(gettext, "Virtualitems", _resource, "displayname");
    titleText[format [localize "str_notF_Gather_Success", _itemname, _diff], "PLAin"];
    [20, 0, 1] call cat_craftingV2_fnc_randomPlan;
};

sleep 1;
life_action_inUse = false;