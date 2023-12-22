#include "hc_macros.hpp"

/*
    File: fn_initHC.sqf
    Author: Nanou

    Description:
    Initialize the headless client.
*/

// Zeitstempel für die Diagnoseprotokollierung
_timeStamp = diag_tickTime;
diag_log "----------------------------------------------------------------------------------------------------";
diag_log "------------------------------------ Starting Altis Life HC Init -----------------------------------";
diag_log format["-------------------------------------------- Version %1 -----------------------------------------",(LIFE_SETTINGS(getText,"framework_version"))];
diag_log "----------------------------------------------------------------------------------------------------";

// Private Variable zur Überprüfung, ob extDB3 geladen ist
private ["_timeStamp","_extDBNotLoaded"];

// Überprüfen Sie, ob die Headless-Client-Unterstützung in den Einstellungen aktiviert ist
if (EXTDB_SETTING(getNumber,"HeadlessSupport") isEqualTo 0) exitWith {};

_extDBNotLoaded = "";

// Überprüfen Sie, ob die SQL-ID in der UI-Namespace-Variablen vorhanden ist
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

// Wenn extDB3 nicht vollständig initialisiert ist, beende den Rest des Initialisierungsprozesses
if (_extDBNotLoaded isEqualType []) then {
    [] spawn {
        for "_i" from 0 to 1 step 0 do {
            [0,"There is a problem with the Headless Client, please contact an administrator."] remoteExecCall ["life_fnc_broadcast",RCLIENT];
            sleep 120;
        };
    };
};

if (_extDBNotLoaded isEqualType []) exitWith {}; // extDB3-HC hat sich nicht vollständig initialisiert, beende den Rest des Initialisierungsprozesses.

// Führe verschiedene Funktionen aus, um die Datenbank zu bereinigen und vorzubereiten
["resetLifeVehicles", 1] call HC_fnc_asyncCall;
["deleteDeadVehicles", 1] call HC_fnc_asyncCall;
["deleteOldHouses", 1] call HC_fnc_asyncCall;
["deleteOldGangs", 1] call HC_fnc_asyncCall;

// Starte die Bereinigungsfunktion im Hintergrund
[] spawn HC_fnc_cleanup;

// Initialisiere die Jagdzonen
["hunting_zone",30] spawn HC_fnc_huntingZone;

// Liste der erlaubten Funktionen, die vom HC verarbeitet werden können (von externen Quellen)
HC_MPAllowedFuncs = [
    "hc_fnc_insertrequest",
    "hc_fnc_insertvehicle",
    "hc_fnc_queryrequest",
    "hc_fnc_updatepartial",
    "hc_fnc_updaterequest",
    "hc_fnc_cleanup",
    "hc_fnc_huntingzone",
    "hc_fnc_setplaytime",
    "hc_fnc_getplaytime",
    "hc_fnc_insertgang",
    "hc_fnc_queryplayergang",
    "hc_fnc_removegang",
    "hc_fnc_updategang",
    "hc_fnc_addcontainer",
    "hc_fnc_addhouse",
    "hc_fnc_deletedbcontainer",
    "hc_fnc_fetchplayerhouses",
    "hc_fnc_sellhouse",
    "hc_fnc_sellhousecontainer",
    "hc_fnc_updatehousecontainers",
    "hc_fnc_updatehousetrunk",
    "hc_fnc_keymanagement",
    "hc_fnc_vehiclecreate",
    "hc_fnc_spawnvehicle",
    "hc_fnc_vehiclestore",
    "hc_fnc_chopshopsell",
    "hc_fnc_getvehicles",
    "hc_fnc_vehicledelete",
    "hc_fnc_vehicleupdate",
    "hc_fnc_jailsys",
    "hc_fnc_spikestrip",
    "hc_fnc_wantedadd",
    "hc_fnc_wantedbounty",
    "hc_fnc_wantedcrimes",
    "hc_fnc_wantedfetch",
    "hc_fnc_wantedperson",
    "hc_fnc_wantedprofupdate",
    "hc_fnc_wantedremove"
];

CONSTVAR(HC_MPAllowedFuncs);

// Starte einen Hintergrundprozess, um die `serv_sv_use`-Variable alle 60 Sekunden zu aktualisieren
[] spawn {
    for "_i" from 0 to 1 step 0 do {
        uiSleep 60;
        publicVariableServer "serv_sv_use";
    };
};

// Setze eine Variable, um anzuzeigen, dass der HC aktiv ist
life_HC_isActive = true;
publicVariable "life_HC_isActive";

// Protokollierung des Endes der Initialisierung
diag_log "----------------------------------------------------------------------------------------------------";
diag_log format ["                 End of Altis Life HC Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "----------------------------------------------------------------------------------------------------";
