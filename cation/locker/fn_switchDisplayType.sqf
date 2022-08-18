/*
    File: fn_switchDisplayType.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Switches item categories    
*/
params[["_type",-1,[0]]];

private _display = findDisplay 5000;
switch (_type) do {
    case 0: {
        ctrlShow[5034,true];
        ctrlShow[5036,false];
        ctrlShow[5038,false];
        ctrlShow[5040,false];
    };
    case 1: {
        ctrlShow[5034,false];
        ctrlShow[5036,true];
        ctrlShow[5038,false];
        ctrlShow[5040,false];
    };
    case 2: {
        ctrlShow[5034,false];
        ctrlShow[5036,false];
        ctrlShow[5038,true];
        ctrlShow[5040,false];
    };
    case 3: {
        ctrlShow[5034,false];
        ctrlShow[5036,false];
        ctrlShow[5038,false];
        ctrlShow[5040,true];
    };
};
_display setVariable ["type",_type];
[] call cat_locker_fnc_refreshDialog;