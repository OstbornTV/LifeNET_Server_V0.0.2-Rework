/*
    File: fn_query.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
    Sends a request out to the server to check for locker information.
*/
[] spawn {
    if (!hasInterface) exitWith {};
	waitUntil {!isNull (findDisplay 46)};

    if (getNumber(missionConfigFile >> "Cation_Locker" >> "HeadlessSupport") isEqualTo 0) then {
        [getPlayerUID player,playerSide,player] remoteExecCall ["cat_locker_fnc_fetchTrunk",2];
    } else {
        if (life_HC_isActive) then {
            [getPlayerUID player,playerSide,player] remoteExecCall ["cat_locker_fnc_fetchTrunkHC",HC_Life];
        } else {
            [getPlayerUID player,playerSide,player] remoteExecCall ["cat_locker_fnc_fetchTrunk",2];
        };
    };
};