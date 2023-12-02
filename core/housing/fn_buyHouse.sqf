#include "..\..\script_macros.hpp"
/*
    File: fn_buyHouse.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Kauft das Haus?
*/
// Deklariere lokale Variablen
private ["_house","_uid","_action","_houseCfg"];
// Hole den übergebenen Parameter (das Hausobjekt)
_house = param [0,objNull,[objNull]];
// Hole die Spieler-UID
_uid = getPlayerUID player;

// Überprüfe, ob das Haus ungültig ist
if (isNull _house) exitWith {};
// Überprüfe, ob es sich um ein Hausobjekt handelt
if (!(_house isKindOf "House_F")) exitWith {};
// Überprüfe, ob das Haus bereits gekauft wurde
if (_house getVariable ["house_owned",false]) exitWith {hint localize "STR_House_alreadyOwned";};
// Überprüfe, ob das Haus bereits zum Verkauf steht
if (!isNil {(_house getVariable "house_sold")}) exitWith {hint localize "STR_House_Sell_Process"};
// Überprüfe, ob der Spieler die Hauslizenz besitzt
if (!license_civ_home) exitWith {hint localize "STR_House_License"};
// Überprüfe, ob die maximale Anzahl von Häusern erreicht ist
if (count life_houses >= (LIFE_SETTINGS(getNumber,"house_limit"))) exitWith {hint format [localize "STR_House_Max_House",LIFE_SETTINGS(getNumber,"house_limit")]};
// Schließe das Dialogfeld
closeDialog 0;

// Hole die Konfiguration für das Haus aus der Funktion life_fnc_houseConfig
_houseCfg = [(typeOf _house)] call life_fnc_houseConfig;
// Überprüfe, ob die Konfiguration gültig ist
if (count _houseCfg isEqualTo 0) exitWith {};

// Zeige eine Bestätigungsmeldung mit dem Preis des Hauses an
_action = [
    format [localize "STR_House_BuyMSG",
    [(_houseCfg select 0)] call life_fnc_numberText,
    (_houseCfg select 1)],localize "STR_House_Purchase",localize "STR_Global_Buy",localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

// Überprüfe, ob der Kauf bestätigt wurde
if (_action) then {
    // Überprüfe, ob der Spieler genügend Geld hat
    if (BANK < (_houseCfg select 0)) exitWith {hint format [localize "STR_House_NotEnough"]};
    // Ziehe den Kaufpreis vom Bankguthaben ab
    BANK = BANK - (_houseCfg select 0);
    // Aktualisiere die Bankdaten auf dem Server
    [1] call SOCK_fnc_updatePartial;

    // Führe die Funktion zum Hinzufügen des Hauses aus, abhängig von der Aktivierung des Headless Clients
    if (life_HC_isActive) then {
        [_uid,_house] remoteExec ["HC_fnc_addHouse",HC_Life];
    } else {
        [_uid,_house] remoteExec ["TON_fnc_addHouse",RSERV];
    };

    // Logge den Hauskauf, wenn die erweiterte Protokollierung aktiviert ist
    if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
        // Logge den Hauskauf im Chat oder in der BattlEye-Konsole
        if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
            advanced_log = format [localize "STR_DL_AL_boughtHouse_BEF",[(_houseCfg select 0)] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
        } else {
            advanced_log = format [localize "STR_DL_AL_boughtHouse",profileName,(getPlayerUID player),[(_houseCfg select 0)] call life_fnc_numberText,[BANK] call life_fnc_numberText,[CASH] call life_fnc_numberText];
        };
        // Sende die erweiterten Protokolldaten an den Server
        publicVariableServer "advanced_log";
    };

    // Setze die Eigentümerinformationen und andere Hausvariablen
    _house setVariable ["house_owner",[_uid,profileName],true];
    _house setVariable ["locked",true,true];
    _house setVariable ["containers",[],true];
    _house setVariable ["uid",floor(random 99999),true];

    // Füge das Haus zur Liste der Fahrzeuge hinzu
    life_vehicles pushBack _house;
    // Füge das Haus zur Liste der Häuser hinzu
    life_houses pushBack [str(getPosATL _house),[]];
    // Erstelle einen Marker für das Haus
    _marker = createMarkerLocal [format ["house_%1",(_house getVariable "uid")],getPosATL _house];
    // Hole den Anzeigenamen des Hauses aus der Konfiguration
    _houseName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _house), "displayName");
    // Setze die Text- und Farbeigenschaften des Markers
    _marker setMarkerTextLocal _houseName;
    _marker setMarkerColorLocal "ColorBlue";
    _marker setMarkerTypeLocal "loc_Lighthouse";
    // Deaktiviere alle Türen des Hauses
    _numOfDoors = FETCH_CONFIG2(getNumber,"CfgVehicles",(typeOf _house),"numberOfDoors");
    for "_i" from 1 to _numOfDoors do {
        _house setVariable [format ["bis_disabled_Door_%1",_i],1,true];
    };
};