#include "..\..\script_macros.hpp"
/*
File: fn_houseMenu.sqf
Author: Bryan "tonic" Boardwine

Description:
Building interaction menu
*/
#define Btn1 37450
#define Btn2 37451
#define Btn3 37452
#define Btn4 37453
#define Btn5 37454
#define Btn6 37455
#define Btn7 37456
#define Btn8 37457
#define Title 37401

private ["_display", "_curTarget", "_Btn1", "_Btn2", "_Btn3", "_Btn4", "_Btn5", "_Btn6", "_Btn7", "_Btn8"];
disableSerialization;
_curTarget = param [0, objNull, [objNull]];
if (isNull _curTarget) exitwith {};
_houseCfg = [(typeOf _curTarget)] call life_fnc_houseConfig;
if (count _houseCfg isEqualto 0 && playerside isEqualto civilian) exitwith {};

if (!dialog) then {
    createdialog "pinteraction_Menu";
};

_Btn1 = CONTROL(37400, Btn1);
_Btn2 = CONTROL(37400, Btn2);
_Btn3 = CONTROL(37400, Btn3);
_Btn4 = CONTROL(37400, Btn4);
_Btn5 = CONTROL(37400, Btn5);
_Btn6 = CONTROL(37400, Btn6);
_Btn7 = CONTROL(37400, Btn7);
_Btn8 = CONTROL(37400, Btn8);
{_x ctrlShow false;} forEach [_Btn1, _Btn2, _Btn3, _Btn4, _Btn5, _Btn6, _Btn7, _Btn8];

life_pinact_curTarget = _curTarget;

if (_curTarget in life_hideoutBuildings) exitwith {
    closedialog 0;
    hint localize "str_House_Hideout";
};

if (_curTarget isKindOf "House_F" && playerside isEqualto west) exitwith {
    private _vaultHouse = [[["WL_Rosche", "land_Research_house_V1_F"]]] call life_util_fnc_terrainsort;
    private _wl_roscheArray = [16019.5, 16952.9, 0];
    private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainsort;
    
    if ((nearestobject [_pos, "land_dome_Big_F"]) isEqualto _curTarget || (nearestobject [_pos, _vaultHouse]) isEqualto _curTarget) then {
        _Btn1 ctrlsettext localize "str_pinAct_Repair";
        _Btn1 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_repairdoor;";
        _Btn1 ctrlShow true;
        
        _Btn2 ctrlsettext localize "str_pinAct_CloseOpen";
        _Btn2 buttonsetAction "closedialog 0; [life_pinact_curTarget] call life_fnc_dooranimate;";
        _Btn2 ctrlShow true;
        
    } else {
        if (!isnil {
            _curTarget getVariable "house_owner"
        }) then {
            _Btn1 ctrlsettext localize "str_House_Raid_owner";
            _Btn1 buttonsetAction "[life_pinact_curTarget] call life_fnc_copHouseowner;";
            _Btn1 ctrlShow true;
            
            _Btn2 ctrlsettext localize "str_pinAct_Breakdown";
            _Btn2 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_copBreakdoor;";
            _Btn2 ctrlShow true;
            
            _Btn3 ctrlsettext localize "str_pinAct_SearchHouse";
            _Btn3 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_raidHouse;";
            _Btn3 ctrlShow true;
            
            if (player distance _curTarget > 3.6) then {
                _Btn3 ctrlEnable false;
            };
            
            _Btn4 ctrlsettext localize "str_pinAct_lockHouse";
            _Btn4 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_lockupHouse;";
            _Btn4 ctrlShow true;
        } else {
            closedialog 0;
        };
    };
};

if (!(_curTarget in life_vehicles) || isnil {
    _curTarget getVariable "house_owner"
}) then {
    private _isHouse = (isClass (missionConfigFile >> "Housing" >> worldName >> typeOf _curTarget));
    private _buildingPurchasestring = [
        "str_pinAct_BuyGarage",
        "str_pinAct_BuyHouse"
    ] select _isHouse;
    
    _Btn1 ctrlsettext localize _buildingPurchasestring;
    _Btn1 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_buyHouse;";
    _Btn1 ctrlShow true;
    
    if (!isnil {
        _curTarget getVariable "house_owner"
    }) then {
        _Btn1 ctrlEnable false;
    };
    
    if (_isHouse) then {
        if (getNumber (missionConfigFile >> "Housing" >> worldName >> (typeOf _curTarget) >> "canGarage") isEqualto 1) then {
            _Btn2 ctrlsettext localize "str_pinAct_GarageExt";
            _Btn2 buttonsetAction 'hint format [localize "str_pinAct_GarageExtnotF", [LifE_setTinGS(getNumber, "houseGarage_buyPrice")] call life_fnc_numbertext];';
            _Btn2 ctrlShow true;
        };
    };
} else {
    if (isClass (missionConfigFile >> "Garages" >> worldName >> (typeOf _curTarget))) then {
        _Btn1 ctrlsettext localize "str_pinAct_SellGarage";
        _Btn1 buttonSetAction "gettingBought = gettingBought + 1; diag_log gettingBought; closeDialog 0; [life_pInact_curTarget] spawn life_fnc_sellHouse;";
        _Btn1 ctrlShow true;
        
        if !(((_curTarget getVariable "house_owner") select 0) isEqualto getplayerUID player) then {
            _Btn1 ctrlEnable false;
        };
        
        _Btn2 ctrlsettext localize "str_pinAct_AccessGarage";
        _Btn2 buttonsetAction "closedialog 0; [life_pinact_curTarget, ""Car""] spawn life_fnc_vehicleGarage;";
        _Btn2 ctrlShow true;
        
        _Btn3 ctrlsettext localize "str_pinAct_StoreVeh";
        _Btn3 buttonsetAction "closedialog 0; [life_pinact_curTarget, player] spawn life_fnc_storevehicle;";
        _Btn3 ctrlShow true;
    } else {
        _Btn1 ctrlsettext localize "str_pinAct_SellHouse";
        _Btn1 buttonSetAction "gettingBought = gettingBought + 1; diag_log gettingBought; closeDialog 0; [life_pInact_curTarget] spawn life_fnc_sellHouse;";
        _Btn1 ctrlShow true;
        
        if (((_curTarget getVariable "house_owner") select 0) != (getplayerUID player)) then {
            _Btn1 ctrlEnable false;
        };
        
        if (_curTarget getVariable ["locked", false]) then {
            _Btn2 ctrlsettext localize "str_pinAct_UnlockStorage";
        } else {
            _Btn2 ctrlsettext localize "str_pinAct_lockStorage";
        };
        _Btn2 buttonsetAction "closedialog 0; [life_pinact_curTarget] call life_fnc_lockHouse;";
        _Btn2 ctrlShow true;
        
        if (isNull (_curTarget getVariable ["lightSource", objNull])) then {
            _Btn3 ctrlsettext localize "str_pinAct_LightsOn";
        } else {
            _Btn3 ctrlsettext localize "str_pinAct_LightsOff";
        };
        _Btn3 buttonsetAction "closedialog 0; [life_pinact_curTarget] call life_fnc_lightHouseaction;";
        _Btn3 ctrlShow true;
        
        if (getNumber (missionConfigFile >> "Housing" >> worldName >> (typeOf _curTarget) >> "canGarage") isEqualto 1 && {
            !(_curTarget getVariable ["blacklistedGarage", false])
        }) then {
            if (_curTarget getVariable ["garageBought", false]) then {
                _Btn4 ctrlsettext localize "str_pinAct_SellGarage";
                _Btn4 buttonSetAction "gettingBought = gettingBought + 1; diag_log gettingBought; closeDialog 0; [life_pInact_curTarget] spawn life_fnc_sellHouseGarage;";
                _Btn4 ctrlShow true;
                
                if (((_curTarget getVariable "house_owner") select 0) != (getplayerUID player)) then {
                    _Btn4 ctrlEnable false;
                };
                
                _Btn5 ctrlsettext localize "str_pinAct_AccessGarage";
                _Btn5 buttonsetAction "closedialog 0; [life_pinact_curTarget, ""Car""] spawn life_fnc_vehicleGarage;";
                _Btn5 ctrlShow true;
                
                _Btn6 ctrlsettext localize "str_pinAct_StoreVeh";
                _Btn6 buttonsetAction "closedialog 0; [life_pinact_curTarget, player] spawn life_fnc_storevehicle;";
                _Btn6 ctrlShow true;
            } else {
                _Btn5 ctrlsettext localize "str_pinAct_BuyGarage";
                _Btn5 buttonsetAction "closedialog 0; [life_pinact_curTarget] spawn life_fnc_buyHouseGarage;";
            };
            
            _Btn5 ctrlShow true;

        };

        if (life_pinact_curTarget getVariable ["security", false]) then {
            _Btn6 ctrlsettext format [["resetAlarm"] call cat_alarm_fnc_gettext];
            if (life_pinact_curTarget getVariable ["alarm", false]) then {
                _Btn6 buttonsetAction "[life_pinact_curTarget] call cat_alarm_fnc_houseAlarmOff;";
            } else {
                _Btn6 ctrlEnable false;
            };
        } else {
            _Btn6 ctrlsettext format [["buyAlarm"] call cat_alarm_fnc_gettext];
            _Btn6 buttonsetAction "[life_pinact_curTarget] spawn cat_alarm_fnc_houseAlarmBuy;";
        };
        _Btn6 ctrlShow true;
        if (!(((_curTarget getVariable "house_owner") select 0) isEqualto (getplayerUID player))) then {
            _Btn6 ctrlEnable false;
        };
    };
};