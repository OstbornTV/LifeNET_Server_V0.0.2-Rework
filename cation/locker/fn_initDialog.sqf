/*
    File: fn_initDialog.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Opens locker dialog   
*/
if (isNull player || !alive player || (player getVariable ["restrained",false]) || (player getVariable ["Escorting",false]) || life_istazed || life_action_inUse) exitWith {closeDialog 0;};
if ((getNumber(missionConfigFile >> "Cation_Locker" >> "version")) > 4) then {
    if ((player getVariable ["playerSurrender",false]) || life_isknocked) exitWith {closeDialog 0;};
};
if (dialog) exitWith {};
if (!createDialog "LockerMenu") exitWith {};
disableSerialization;

waitUntil {!isNull (uiNamespace getVariable ["LockerMenu",displayNull])};
private _ui = uiNamespace getVariable ["LockerMenu",displayNull];
private _progressBar = _ui displayCtrl 5002;
_progressBar progressSetPosition 0;
_progressBar ctrlCommit 0;

private _display = findDisplay 5000;
(_display displayCtrl 5001) ctrlSetText format[["Locker"] call cat_locker_fnc_getText];
(_display displayCtrl 5003) ctrlSetText format[["LockerInventory"] call cat_locker_fnc_getText];
(_display displayCtrl 5007) ctrlSetText format[["Take"] call cat_locker_fnc_getText];
(_display displayCtrl 5010) ctrlSetText format[["Store"] call cat_locker_fnc_getText];
(_display displayCtrl 5011) ctrlSetText format[["Close"] call cat_locker_fnc_getText];
(_display displayCtrl 5012) ctrlSetText format[["Upgrade"] call cat_locker_fnc_getText];

(_display displayCtrl 5014) ctrlSetTooltip format[["VItems"] call cat_locker_fnc_getText];
(_display displayCtrl 5016) ctrlSetTooltip format[["Weapons"] call cat_locker_fnc_getText];
(_display displayCtrl 5018) ctrlSetTooltip format[["Items"] call cat_locker_fnc_getText];
(_display displayCtrl 5020) ctrlSetTooltip format[["Equipment"] call cat_locker_fnc_getText];
(_display displayCtrl 5022) ctrlSetTooltip format[["PlayerInventory"] call cat_locker_fnc_getText];
(_display displayCtrl 5024) ctrlSetTooltip format[["VehicleInventory"] call cat_locker_fnc_getText];

private _trunk = cat_locker_trunk;
private _level = cat_locker_level;
private _sizePrice = (getArray(missionConfigFile >> "Cation_Locker" >> "locker_size_price"));
if (_level >= count _sizePrice) then {
    ctrlShow [5012,false];
};
_display setVariable ["type",0];
_display setVariable ["mode",0];
cat_locker_vehicle = objNull;

ctrlShow[5036,false];
ctrlShow[5038,false];
ctrlShow[5040,false];
ctrlShow[5044,false];

[] call cat_locker_fnc_refreshDialog;

[] spawn {
    waitUntil {isNull (findDisplay 5000)};
    [3] call SOCK_fnc_updatePartial;
    private _trunk = cat_locker_trunk;
    private _level = cat_locker_level;
    if (getNumber(missionConfigFile >> "Cation_Locker" >> "HeadlessSupport") isEqualTo 0) then {
        [_trunk,_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunk",2];
    } else {
        if (life_HC_isActive) then {
            [_trunk,_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunkHC",HC_Life];
        } else {
            [_trunk,_level,getPlayerUID player,playerSide] remoteExecCall ["cat_locker_fnc_updateTrunk",2];
        };
    };
};