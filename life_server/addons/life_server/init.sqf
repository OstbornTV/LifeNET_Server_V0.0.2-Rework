#include "script_macros.hpp"

/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine

    Edit: Nanou for HeadlessClient optimization.
    Please read support for more informations.

    Description:
    Initialize the server and required systems.
*/

// Zeitstempel für die Diagnoseprotokollierung
_timeStamp = diag_tickTime;
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "---------------------------------- Starting Altis Life Server Init ---------------------------------";
diag_log format["------------------------------------------ Version %1 -------------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

private ["_dome","_rsb","_timeStamp","_extDBNotLoaded"];

// Variablen für die Aktivierung des Headless Clients und extDB3
DB_Async_Active = false;
DB_Async_ExtraLock = false;
life_server_isReady = false;
_extDBNotLoaded = "";
serv_sv_use = [];
publicVariable "life_server_isReady";
life_save_civilian_position = if (LIFE_SETTINGS(getNumber,"save_civilian_position") isEqualTo 0) then {false} else {true};

/*
    Headless Client vorbereiten.
*/
life_HC_isActive = false;
publicVariable "life_HC_isActive";
HC_Life = false;
publicVariable "HC_Life";

// Wenn Headless-Client-Unterstützung aktiviert ist, führe das entsprechende Initialisierungsskript aus
if (EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 1) then {
    [] execVM "\life_server\initHC.sqf";
};

/*
    extDB vorbereiten, bevor der Initialisierungsprozess für den Server gestartet wird.
*/

// Überprüfen, ob die SQL-ID in der UI-Namespace-Variablen vorhanden ist
if (isNil {uiNamespace getVariable "life_sql_id"}) then {
    // Wenn nicht vorhanden, initialisiere extDB3 und füge die Datenbankverbindung hinzu
    life_sql_id = round(random(9999));
    CONSTVAR(life_sql_id);
    uiNamespace setVariable ["life_sql_id",life_sql_id];
        try {
        // Füge die Datenbank und das Protokoll für die extDB3-Verbindung hinzu
        _result = EXTDB format ["9:ADD_DATABASE:%1",EXTDB_SETTING(getText,"DatabaseName")];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
        _result = EXTDB format ["9:ADD_DATABASE_PROTOCOL:%2:SQL_CUSTOM:%1:AL.ini",FETCH_CONST(life_sql_id),EXTDB_SETTING(getText,"DatabaseName")];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
    } catch {
        diag_log _exception;
        _extDBNotLoaded = [true, _exception];
    };
    if (_extDBNotLoaded isEqualType []) exitWith {};
    EXTDB "9:LOCK";
    diag_log "extDB3: Connected to Database";
} else {
    // Wenn vorhanden, verwende die vorhandene SQL-ID
    life_sql_id = uiNamespace getVariable "life_sql_id";
    CONSTVAR(life_sql_id);
    diag_log "extDB3: Still Connected to Database";
};

// Wenn extDB3 nicht vollständig initialisiert ist, setze die entsprechende Variable und beende den Rest des Initialisierungsprozesses
if (_extDBNotLoaded isEqualType []) exitWith {
    life_server_extDB_notLoaded = true;
    publicVariable "life_server_extDB_notLoaded";
};
life_server_extDB_notLoaded = false;
publicVariable "life_server_extDB_notLoaded";

/* Gespeicherte Prozeduren für SQL-basierte Bereinigungen ausführen */
["resetLifeVehicles", 1] call DB_fnc_asyncCall;
["deleteDeadVehicles", 1] call DB_fnc_asyncCall;
["deleteOldHouses", 1] call DB_fnc_asyncCall;
["deleteOldGangs", 1] call DB_fnc_asyncCall;

// Wenn die Option "save_civilian_position_restart" aktiviert ist, aktualisiere die Position der Zivilisten
if (LIFE_SETTINGS(getNumber,"save_civilian_position_restart") isEqualTo 1) then {
    [] spawn {
        ["updateCivAlive", 1] call DB_fnc_asyncCall;
    };
};

/* Kartenbasierte serverseitige Initialisierung. */
master_group attachTo[bank_obj,[0,0,0]];

// Waffen von Nicht-Spielern entfernen
{
    if (!isPlayer _x) then {
        _npc = _x;
        {
            if (_x != "") then {
                _npc removeWeapon _x;
            };
        } forEach [primaryWeapon _npc,secondaryWeapon _npc,handgunWeapon _npc];
    };
} forEach allUnits;

[8,true,12] execFSM "\life_server\FSM\timeModule.fsm";

// Echtzeitmodul für Sommerinitialisierung ausführen
[] execFSM "\life_server\FSM\sommer_realtime.fsm";

// Admin-, Medic- und Cop-Levels initialisieren
life_adminLevel = 0;
life_medicLevel = 0;
life_copLevel = 0;
CONST(JxMxE_PublishVehicle,"false");

// Funkkanäle für West/Unabhängige/Zivilisten erstellen
life_radio_west = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];
life_radio_civ = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];
life_radio_indep = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];

// Menge an Gold in der Bundesreserve zu Missionsbeginn setzen
fed_bank setVariable ["safe",count playableUnits,true];

// Event-Handler für das Trennen von Spielern hinzufügen
addMissionEventHandler ["HandleDisconnect",{_this call TON_fnc_clientDisconnect; false;}];

// Event-Handler für Logs hinzufügen
"money_log" addPublicVariableEventHandler {diag_log (_this select 1)};
"advanced_log" addPublicVariableEventHandler {diag_log (_this select 1)};

// Verschiedene für die Mission erforderliche Dinge
life_wanted_list = [];

// Funktionen für Häuser und Bereinigung initialisieren
[] spawn TON_fnc_initHouses;
cleanup = [] spawn TON_fnc_cleanup;

TON_fnc_playtime_values = [];
TON_fnc_playtime_values_request = [];

// Nur für den Fall, dass sich der Headless-Client vor anderen verbindet
publicVariable "TON_fnc_playtime_values";
publicVariable "TON_fnc_playtime_values_request";

// Bundesreservengebäude einrichten
private _vaultHouse = [[["WL_Rosche", "Land_Medevac_house_V1_F"]]] call life_util_fnc_terrainSort;
private _wl_roscheArray = [16019.5,16952.9,0];
private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

_dome = nearestObject [_pos,"Land_Dome_Big_F"];
_rsb = nearestObject [_pos,_vaultHouse];

for "_i" from 1 to 3 do {_dome setVariable [format ["bis_disabled_Door_%1",_i],1,true]; _dome animateSource [format ["Door_%1_source", _i], 0];};
_dome setVariable ["locked",true,true];
_rsb setVariable ["locked",true,true];
_rsb setVariable ["bis_disabled_Door_1",1,true];
_dome allowDamage false;
_rsb allowDamage false;

/* Clients mitteilen, dass der Server bereit ist und Anfragen akzeptiert */
life_server_isReady = true;
publicVariable "life_server_isReady";

/* Jagdzone(n) initialisieren */
aiSpawn = ["hunting_zone",30] spawn TON_fnc_huntingZone;

// Initialisierung von Event-Handlern für Leichen und Spike-Stripes
server_corpses = [];
addMissionEventHandler ["EntityRespawned", {_this call TON_fnc_entityRespawned}];
addMissionEventHandler ["EntityKilled", {_this call TON_fnc_entityKilled}];

server_spikes = [];

diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["               End of Altis Life Server Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "----------------------------------------------------------------------------------------------------";
