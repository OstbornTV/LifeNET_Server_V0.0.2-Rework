/*
    File: fn_init.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Initializes trade system
*/
[] spawn {
    private ["_exit","_keyDown","_shift","_ctrlKey","_alt"];
    waitUntil {!(isNull (findDisplay 46))};
    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        _keyDown = _this select 1;
        _shift = switch (_this select 2) do { case true: {1}; case false: {0}; default {0};};
        _ctrlKey = switch (_this select 3) do { case true: {1}; case false: {0}; default {0};};
        _alt = switch (_this select 4) do { case true: {1}; case false: {0}; default {0};};
        if (!(_keyDown isEqualTo (getNumber(missionConfigFile >> "Cation_Trade" >> "key")))) exitWith {false};
        if (!(_shift isEqualTo (getNumber(missionConfigFile >> "Cation_Trade" >> "shift")))) exitWith {false};
        if (!(_ctrlKey isEqualTo (getNumber(missionConfigFile >> "Cation_Trade" >> "ctrl")))) exitWith {false};
        if (!(_alt isEqualTo (getNumber(missionConfigFile >> "Cation_Trade" >> "alt")))) exitWith {false};
        if (!(isPlayer cursorObject)) exitWith {false};
        if ((player distance cursorObject) > 5) exitWith {false};
        if ((getNumber(missionConfigFile >> "Cation_Trade" >> "onlyFractionInternal") isEqualTo 1) && (!(playerSide isEqualTo (side cursorObject)))) exitWith {false};
        [cursorObject] call cat_trade_fnc_openVendor;
        true;
    }];
};