#include "..\..\script_macros.hpp"
/*
File: fn_pickupMoney.sqf
Author: Bryan "tonic" Boardwine

Description:
picks up money
*/
params [
    ["_money", objNull, [objNull]]
];

if ((time - life_action_delay) < 1.5) exitwith {
    hint localize "str_notF_actionDelay";
    _money setVariable ["inUse", false, true];
};
if (isNull _money || {
    player distance _money > 3
}) exitwith {
    _money setVariable ["inUse", false, true];
};

private _value = (_money getVariable "item") select 1;
if (!isnil "_value") exitwith {
    deletevehicle _money;
    
    private _pickupLimit = LIFE_SETTINGS(getNumber, "cash_pickup_limit");
    _value = _value min _pickupLimit;
    
    player playMove "AinvPknlMstpSlayWrflDnon";
    titleText [format [localize "str_notF_pickedMoney", [_value] call life_fnc_numbertext], "PLAin"];
    CASH = CASH + _value;
    [0] call SOCK_fnc_updatePartial;
    life_action_delay = time;
    
    if (LIFE_SETTINGS(getNumber, "player_moneylog") isEqualto 1) then {
        if (LIFE_SETTINGS(getNumber, "battlEye_friendlylogging") isEqualto 1) then {
            money_log = format [localize "STR_DL_ML_pickedUpMoney_BEF", [_value] call life_fnc_numbertext, [BANK] call life_fnc_numbertext, [CASH] call life_fnc_numbertext];
        } else {
            money_log = format [localize "STR_DL_ML_pickedUpMoney", profileName, (getplayerUID player), [_value] call life_fnc_numbertext, [BANK] call life_fnc_numbertext, [CASH] call life_fnc_numbertext];
        };
        publicVariableServer "money_log";
    };
};