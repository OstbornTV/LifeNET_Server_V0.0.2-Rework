/*
    File: fn_refreshPermDialog.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Refreshes management dialog
*/
params[
	["_receiver",objNull,[objNull]]
];
if (isNull _receiver) exitWith {closeDialog 0;};
if (!dialog) then {
	createDialog "Cat_perm_management";
};
ctrlShow [9501,false];
ctrlShow [9502,false];
ctrlShow [9503,false];
ctrlShow [9504,false];
ctrlShow [9506,false];
ctrlShow [9507,false];
ctrlShow [9508,false];
ctrlShow [9509,false];        
ctrlShow [9510,false];        
ctrlShow [9511,false];
ctrlShow [9512,false];        
ctrlShow [9513,false];        
ctrlShow [9514,false];
ctrlShow [9515,false];        
ctrlShow [9516,false];        
ctrlShow [9517,false];
ctrlShow [9518,false];        
ctrlShow [9519,false];        
ctrlShow [9520,false];
ctrlShow [9521,true];

sleep 2;

if (getNumber(missionConfigFile >> "Cation_Perm" >> "HeadlessSupport") isEqualTo 0) then {
    [_receiver,player,getPlayerUID _receiver,playerSide] remoteExecCall ["cat_perm_fnc_getInfos",2];
} else {
    if (life_HC_isActive) then {
        [_receiver,player,getPlayerUID _receiver,playerSide] remoteExecCall ["cat_perm_fnc_getInfosHC",HC_Life];
    } else {
        [_receiver,player,getPlayerUID _receiver,playerSide] remoteExecCall ["cat_perm_fnc_getInfos",2];
    };
};