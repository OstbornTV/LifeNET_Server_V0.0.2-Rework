/*
    File: fn_initLevel.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Initializes management system
*/
[] spawn {
    private ["_keyDown","_shift","_ctrlKey","_alt"];
    waitUntil {!(isNull (findDisplay 46))};
    if (!hasInterface) exitWith {};
    if (!isNil "cat_perm_keydown") then {
        (findDisplay 46) displayRemoveEventHandler ["keyDown",cat_perm_keydown];
    };
    waitUntil {!isNil "life_coplevel"};
    waitUntil {!isNil "life_mediclevel"};
    private _exit = true;
    switch (playerSide) do {
        case west: { if ((call life_coplevel) >= (getNumber(missionConfigFile >> "Cation_Perm" >> "mincoplevel"))) then { _exit = false; }; };
        case independent: { if ((call life_mediclevel) >= (getNumber(missionConfigFile >> "Cation_Perm" >> "minmediclevel"))) then { _exit = false; }; };
        default { _exit = true; };
    };
    if (_exit) exitWith {};
    cat_perm_keydown = (findDisplay 46) displayAddEventHandler ["KeyDown", {
        _keyDown = _this select 1;
        _shift = switch (_this select 2) do { case true: {1}; case false: {0}; default {0};};
        _ctrlKey = switch (_this select 3) do { case true: {1}; case false: {0}; default {0};};
        _alt = switch (_this select 4) do { case true: {1}; case false: {0}; default {0};};
        if (!(_keyDown isEqualTo (getNumber(missionConfigFile >> "Cation_Perm" >> "key")))) exitWith {false};
        if (!(_shift isEqualTo (getNumber(missionConfigFile >> "Cation_Perm" >> "shift")))) exitWith {false};
        if (!(_ctrlKey isEqualTo (getNumber(missionConfigFile >> "Cation_Perm" >> "ctrl")))) exitWith {false};
        if (!(_alt isEqualTo (getNumber(missionConfigFile >> "Cation_Perm" >> "alt")))) exitWith {false};
        if ((player distance cursorObject) > 5) exitWith {false};
        if (!(isPlayer cursorObject)) exitWith {false};
        [cursorObject] call cat_perm_fnc_setup;
        true;
    }];
};