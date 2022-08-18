/*
    File: fn_switchDisplayMode.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Switchs from player inventory to vehicle selection menu
*/
params[["_mode",-1,[0]]];

private _display = findDisplay 5000;
if ((_mode isEqualTo 1) && {isNull cat_locker_vehicle}) then {
    _mode = 2;
};
if !(_mode isEqualTo 0) then {
    _display setVariable ["type",0];
};
switch (_mode) do {
    case 0: {
        ctrlShow[5042,true];
        ctrlShow[5044,false];
    };
    default {
        ctrlShow[5042,false];
        ctrlShow[5044,true];
    };
};
_display setVariable ["mode",_mode];
[] call cat_locker_fnc_refreshDialog;