#include "..\..\script_macros.hpp"
/*
    File: fn_sellHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: NiiRoZz

    Description:
    Sells the house and deletes all containers near the house.
*/

private ["_house", "_uid", "_action", "_houseCfg"];

// Überprüfe, ob ein Dialog geöffnet ist und schließe ihn
if (dialog) then {closeDialog 0};

// Parametrisiere das Haus und die Spieler-UID
_house = param [0, objNull, [objNull]];
_uid = getPlayerUID player;

// Überprüfe, ob das Haus existiert und vom richtigen Typ ist
if (isNull _house) exitWith {};
if (!(_house isKindOf "House_F")) exitWith {};
if (isNil {_house getVariable "house_owner"}) exitWith {hint localize "STR_House_noOwner";};
closeDialog 0;

// Rufe die Konfiguration des Hauses ab
_houseCfg = [(typeOf _house)] call life_fnc_houseConfig;
if (count _houseCfg isEqualTo 0) exitWith {};

// Zeige eine Bestätigungsnachricht an den Spieler und warte auf die Aktion
_action = [
    format [localize "STR_House_SellHouseMSG",
    (round((_houseCfg select 0)/2)) call life_fnc_numberText,
    (_houseCfg select 1)], localize "STR_pInAct_SellHouse", localize "STR_Global_Sell", localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {

    // Überprüfe, ob der Verkauf des Hauses aufgrund einer Abklingzeit nicht möglich ist
    if (gettingBought > 1) exitWith { hint localize "STR_House_CoolDown"; };

    // Setze verschiedene Variablen und lösche Marker
    _house setVariable ["house_sold", true, true];
    _house setVariable ["alarm", false, true];
    _house setVariable ["security", false, true];
    deleteMarkerLocal format ["house_%1", (_house getVariable "house_id")];
    deleteMarkerLocal format ["alarm_%1", (_house getVariable "house_id")];

    // Verkaufe das Haus auf dem Headless Client oder Remote Server
    if (life_HC_isActive) then {
        [_house] remoteExecCall ["HC_fnc_sellHouse", HC_Life];
    } else {
        [_house] remoteExecCall ["TON_fnc_sellHouse", RSERV];
    };

    // Setze verschiedene Hausvariablen zurück
    _house setVariable ["locked", false, true];
    deleteMarkerLocal format ["house_%1", _house getVariable "uid"];
    _house setVariable ["uid", nil, true];

    // Aktualisiere das Bankguthaben und sende eine Teilerneuerung an die Datenbank
    BANK = BANK + (round((_houseCfg select 0) / 2));
    [1] call SOCK_fnc_updatePartial;

    // Überprüfe und logge den Verkauf des Hauses
    _index = life_vehicles find _house;
    if (LIFE_SETTINGS(getNumber, "player_advancedLog") isEqualTo 1) then {
        if (LIFE_SETTINGS(getNumber, "battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_soldHouse_BEF", (round((_houseCfg select 0) / 2)), [BANK] call life_fnc_numberText];
        } else {
            advanced_log = format [localize "STR_DL_AL_soldHouse", profileName, (getPlayerUID player), (round((_houseCfg select 0) / 2)), [BANK] call life_fnc_numberText];
        };
        publicVariableServer "advanced_log";
    };

    // Lösche das Haus aus der Fahrzeugliste
    if !(_index isEqualTo -1) then {
        life_vehicles deleteAt _index;
    };

    // Suche und lösche das Haus aus der Liste der Gebäude
    _index = [str(getPosATL _house), life_houses] call life_util_fnc_index;
    if !(_index isEqualTo -1) then {
        life_houses deleteAt _index;
    };

    // Setze die deaktivierten Türen zurück und lösche Container
    _numOfDoors = FETCH_CONFIG2(getNumber, "CfgVehicles", (typeOf _house), "numberOfDoors");
    for "_i" from 1 to _numOfDoors do {
        _house setVariable [format ["bis_disabled_Door_%1", _i], 0, true];
    };

    _containers = _house getVariable ["containers", []];
    if (count _containers > 0) then {
        {
            _x setVariable ["Trunk", nil, true];

            // Verkaufe den Container auf dem Headless Client oder Remote Server
            if (life_HC_isActive) then {
                [_x] remoteExecCall ["HC_fnc_sellHouseContainer", HC_Life];
            } else {
                [_x] remoteExecCall ["TON_fnc_sellHouseContainer", RSERV];
            };

        } forEach _containers;
    };

    _house setVariable ["containers", nil, true];
};

// Warte 60 Sekunden, bevor ein neuer Kauf möglich ist
sleep 60;
gettingBought = 0;
