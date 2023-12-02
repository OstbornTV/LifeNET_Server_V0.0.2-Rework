#include "..\..\script_macros.hpp"
/*
    File: fn_actionKeyHandler.sqf
    Author: Bryan "Tonic" Boardwine

    Beschreibung:
    Master-Aktionstasten-Handler, behandelt Anfragen zum Aufheben verschiedener Gegenstände und
    Interaktion mit anderen Spielern (Polizei = Polizeimenü für Unfesseln, Begleiten, Begleiten stoppen, Verhaften (wenn in der Nähe des Polizeihauptquartiers), usw.).
*/

private _curObject = cursorObject;
if (life_action_inUse) exitWith {}; // Aktion wird bereits verwendet, um Spamming zu verhindern.
if (life_interrupted) exitWith {life_interrupted = false;};
private _isWater = surfaceIsWater (visiblePositionASL player);

if (playerSide isEqualTo west && {player getVariable ["isEscorting",false]}) exitWith {
    [] call life_fnc_copInteractionMenu;
};

if (LIFE_SETTINGS(getNumber,"global_ATM") isEqualTo 1) then{
    // Überprüfe, ob der Spieler in der Nähe eines Geldautomaten ist.
    if ((call life_fnc_nearATM) && {!dialog}) exitWith {
        [] call life_fnc_atmMenu;
    };
};

if (isNull _curObject) exitWith {
    if (_isWater) then {
        // Überprüfe, ob der Spieler in der Nähe von Fischen ist
        (nearestObjects[player,(LIFE_SETTINGS(getArray,"animaltypes_fish")),3]) params [["_fish", objNull]];
        if !(alive _fish) then { // "alive" überprüft auch auf objNull
            [_fish] call life_fnc_catchFish;
        };
    } else {
        // Überprüfe, ob der Spieler in der Nähe von Tieren ist
        (nearestObjects[player,(LIFE_SETTINGS(getArray,"animaltypes_hunting")),3]) params [["_animal", objNull]];
        if !(isNull _animal) then {
            if !(alive _animal) then {
                [_animal] call life_fnc_gutAnimal;
            };
        } else {
            if (playerSide isEqualTo civilian && !life_action_inUse) then {
                private _whatIsIt = [] call life_fnc_whereAmI;
                switch _whatIsIt do {
                    case "mine": {[] spawn life_fnc_mine};
                    default {[] spawn life_fnc_gather};
                };
            };
        };
    };
};

// Überprüfe, ob der Spieler in der Nähe einer Versorgungskiste ist
if ((_curObject isKindOf "B_supplyCrate_F" || _curObject isKindOf "Box_IND_Grenades_F") && {player distance _curObject < 3}) exitWith {
    if (alive _curObject) then {
        [_curObject] call life_fnc_containerMenu;
    };
};

private _vaultHouse = [[["WL_Rosche", "Land_Medevac_house_V1_F"]]] call life_util_fnc_terrainSort;
private _wl_roscheArray = [16019.5,16952.9,0];
private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

// Überprüfe, ob der Spieler in der Nähe eines Hauses oder einer Kuppel ist
if (_curObject isKindOf "House_F" && {player distance _curObject < 12} || ((nearestObject [_pos,"Land_Dome_Big_F"]) isEqualTo _curObject || (nearestObject [_pos,_vaultHouse]) isEqualTo _curObject)) exitWith {
    [_curObject] call life_fnc_houseMenu;
};

if (dialog) exitWith {}; // Wenn ein Dialog geöffnet ist, nicht stören.
if !(isNull objectParent player) exitWith {}; // Er ist in einem Fahrzeug, abbrechen!
life_action_inUse = true;

// Temporärer Failsafe.
[] spawn {
    sleep 60;
    life_action_inUse = false;
};

// Überprüfe, ob es sich um eine Leiche handelt
if (_curObject isKindOf "CAManBase" && {!alive _curObject}) exitWith {
    // Hotfix-Code von ins0
    if ((playerSide isEqualTo west && {(LIFE_SETTINGS(getNumber,"revive_cops") isEqualTo 1)}) || {(playerSide isEqualTo civilian && {(LIFE_SETTINGS(getNumber,"revive_civ") isEqualTo 1)})} || {(playerSide isEqualTo east && {(LIFE_SETTINGS(getNumber,"revive_east") isEqualTo 1)})} || {playerSide isEqualTo independent}) then {
        if (life_inv_defibrillator > 0) then {
            [_curObject] call life_fnc_revivePlayer;
        };
    };
};

// Wenn das Ziel ein Spieler ist, überprüfen Sie, ob das Cop-Menü verwendet werden kann.
if (isPlayer _curObject && _curObject isKindOf "CAManBase") then {
    if ((_curObject getVariable ["restrained",false]) && !dialog && playerSide isEqualTo west) then {
        [_curObject] call life_fnc_copInteractionMenu;
    };
// OK, es war kein Spieler, was ist es dann?
} else {
    private _list = ["landVehicle","Ship","Air"];
    private _isVehicle = if (KINDOF_ARRAY(_curObject,_list)) then {true} else {false};
    private _miscItems = ["Land_BottlePlastic_V1_F","Land_TacticalBacon_F","Land_Can_V3_F","Land_CanisterFuel_F","Land_Suitcase_F"];

    // Es ist ein Fahrzeug! Öffne das Fahrzeuginteraktionsmenü!
    if (_isVehicle) then {
        if (!dialog) then {
            if (player distance _curObject < ((boundingBox _curObject select 1) select 0)+2 && (!(player getVariable ["restrained",false])) && (!(player getVariable ["playerSurrender",false])) && !life_isknocked && !life_istazed) then {
                [_curObject] call life_fnc_vInteractionMenu;
            };
        };
    } else {
        // OK, es war kein Fahrzeug, schauen wir mal, was es sonst sein könnte?
        if ((typeOf _curObject) in _miscItems) then {
            [_curObject,player,false] remoteExecCall ["TON_fnc_pickupAction",RSERV];
        } else {
            // Es war kein sonstiger Gegenstand, ist es Geld?
            if ((typeOf _curObject) isEqualTo "Land_Money_F" && {!(_curObject getVariable ["inUse",false])}) then {
                [_curObject,player,true] remoteExecCall ["TON_fnc_pickupAction",RSERV];
            };
        };
    };
};
