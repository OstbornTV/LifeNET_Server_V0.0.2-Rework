/*
    File: fn_spawnPointSelected.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: Julian Bauer (julian.bauer@cationstudio.com)
    L
    Description:
    Sorts out the spawn point selected and does a map zoom.
*/
disableSerialization;
private ["_spCfg","_sp"];
params [
    ["_control",controlNull,[controlNull]],
    ["_selection",0,[0]]
];

_spCfg = [playerSide] call life_fnc_spawnPointCfg;
_sp = _spCfg select _selection;
[((findDisplay 38500) displayCtrl 38502),1,0.1,getMarkerPos (_sp select 0)] call cat_spawn_fnc_setMapPosition;
life_spawn_point = _sp;

private _randCamX = 75 - floor(random 150);
private _randCamY = 75 - floor(random 150);

spawn_camera camSetPos [((getMarkerPos (life_spawn_point select 0)) select 0)+_randCamX, ((getMarkerPos (life_spawn_point select 0)) select 1)+_randCamY,((getMarkerPos (life_spawn_point select 0)) select 2)+getNumber(missionConfigFile >> "Cation_Spawn" >> "camDistance")];
spawn_camera camSetTarget (getMarkerPos (life_spawn_point select 0));
spawn_camera camCommit 0;

ctrlSetText[38501,format ["%2: %1",_sp select 1,localize "STR_Spawn_CSP"]];

[] spawn {
    private _randCamX = 75 - floor(random 150);
    private _randCamY = 75 - floor(random 150);

    while {alive spawn_camera} do {
        spawn_camera camSetRelPos [_randCamX, _randCamY,getNumber(missionConfigFile >> "Cation_Spawn" >> "camDistance")];
        spawn_camera camCommit 10;
        waitUntil {camCommitted spawn_camera};
        _randCamX = 75 - floor(random 150);
        _randCamY = 75 - floor(random 150);
    };
};