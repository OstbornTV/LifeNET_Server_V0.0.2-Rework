/*
    File: fn_upgrade.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description: 
    Upgrade locker inventory  
*/
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
private _trunk = cat_locker_trunk;
private _nextStage = cat_locker_level + 1;
private _sizePrice = (getArray(missionConfigFile >> "Cation_Locker" >> "locker_size_price"));
if (_nextStage > count _sizePrice) exitWith {};

private _size = _sizePrice select (_nextStage - 1) select 0;
private _price = _sizePrice select (_nextStage - 1) select 1;


private _oldSize = 0;
if !((_nextStage - 1) isEqualTo 0) then {
    _oldSize = _sizePrice select (_nextStage - 2) select 0;
};

private _action = [
    format [(["UpgradeLockerMSG"] call cat_locker_fnc_getText),[_price] call BIS_fnc_numberText,[_size] call BIS_fnc_numberText,[_oldSize] call BIS_fnc_numberText],
    (["UpgradeLocker"] call cat_locker_fnc_getText),
    (["Yes"] call cat_locker_fnc_getText),
    (["No"] call cat_locker_fnc_getText)
] call BIS_fnc_guiMessage;

if (_action) then {
    if (_price > life_cash) exitWith { hint format[["NotEnoughCash"] call cat_locker_fnc_getText]; };
    if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
    if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
        if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
    };
    life_cash = life_cash - _price;
    [0] call SOCK_fnc_updatePartial;
    hint format [(["UpgradeSuccess"] call cat_locker_fnc_getText),_price,_size];
    cat_locker_level = _nextStage;
    cat_locker_maxWeight = _size;
    if (getNumber(missionConfigFile >> "Cation_Locker" >> "HeadlessSupport") isEqualTo 0) then {
        [_trunk,_nextStage,getPlayerUID player,playerSide] remoteExec ["cat_locker_fnc_updateTrunk",2];
    } else {
        if (life_HC_isActive) then {
            [_trunk,_nextStage,getPlayerUID player,playerSide] remoteExec ["cat_locker_fnc_updateTrunkHC",HC_Life];
        } else {
            [_trunk,_nextStage,getPlayerUID player,playerSide] remoteExec ["cat_locker_fnc_updateTrunk",2];
        };
    };

    [] call cat_locker_fnc_refreshDialog;

};
