#include "\life_hc\hc_macros.hpp"

/*
    File: fn_spawnVehicle.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Sends the query request to the database, creates the vehicle if available and not in use or dead.
*/

// Parameterdefinitionen
params [
    ["_vid", -1, [0]],
    ["_pid", "", [""]],
    ["_sp", [], [[],""]],
    ["_unit", objNull, [objNull]],
    ["_price", 0, [0]],
    ["_dir", 0, [0]],
    "_spawntext"
];

// Lokale Variablen initialisieren
private _unit_return = _unit;
private _name = name _unit;
private _side = side _unit;

// Überprüfen, ob _vid und _pid gültige Werte haben
if (_vid isEqualTo -1 || {_pid isEqualTo ""}) exitWith {};

// Überprüfen, ob _vid nicht bereits verwendet wird
if (_vid in serv_sv_use) exitWith {};
serv_sv_use pushBack _vid;

private _servIndex = serv_sv_use find _vid;

private _vInfo = [];

// Informationen über das Fahrzeug abrufen
private _tickTime = diag_tickTime;
private _query = format ["selectVehiclesMore:%1:%2", _vid, _pid];
private _queryResult = [_query, 2] call HC_fnc_asyncCall;

// Debug-Logging, falls Debug-Modus aktiviert ist
if (EXTDB_SETTING(getNumber,"DebugMode") isEqualTo 1) then {
    diag_log "------------- Client Query Request -------------";
    diag_log format ["QUERY: %1",_query];
    diag_log format ["Time to complete: %1 (in seconds)",(diag_tickTime - _tickTime)];
    diag_log format ["Result: %1",_queryResult];
    diag_log "------------------------------------------------";
};

// Wenn die Abfrage fehlschlägt oder leer ist, beende das Skript
if (_queryResult isEqualType "") exitWith {};

// Fahrzeuginformationen aktualisieren
_vInfo = _queryResult;

// Überprüfen, ob Fahrzeuginformationen gültig sind
if (isNil "_vInfo" || {_vInfo isEqualTo []}) exitWith {serv_sv_use deleteAt _servIndex;};

// Überprüfen, ob das Fahrzeug zerstört ist
if ((_vInfo select 5) isEqualTo 0) exitWith {
    serv_sv_use deleteAt _servIndex;
    [1,"STR_Garage_SQLError_Destroyed",true,[_vInfo select 2]] remoteExecCall ["life_fnc_broadcast",_unit];
};

// Überprüfen, ob das Fahrzeug aktiv ist
if ((_vInfo select 6) isEqualTo 1) exitWith {
    serv_sv_use deleteAt _servIndex;
    [1,"STR_Garage_SQLError_Active",true,[_vInfo select 2]] remoteExecCall ["life_fnc_broadcast",_unit];
};

private "_nearVehicles";

// Überprüfen, ob der Spawnpunkt gültig ist
if !(_sp isEqualType "") then {
    _nearVehicles = nearestObjects[_sp,["Car","Air","Ship"],10];
} else {
    _nearVehicles = [];
};

// Überprüfen, ob der Spawnpunkt in Ordnung ist
if !(_nearVehicles isEqualTo []) exitWith {
    serv_sv_use deleteAt _servIndex;
    [_price,_unit_return] remoteExecCall ["life_fnc_garageRefund",_unit];
    [1,"STR_Garage_SpawnPointError",true] remoteExecCall ["life_fnc_broadcast",_unit];
};

// Abfrage für das Update des Fahrzeugs in der Datenbank
_query = format ["updateVehicle:%1:%2", _pid, _vid];
[_query, 1] call HC_fnc_asyncCall;

private "_vehicle";

// Fahrzeug erstellen und positionieren
if (_sp isEqualType "") then {
    _vehicle = createVehicle[(_vInfo select 2),[0,0,999],[],0,"NONE"];
    waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
    _vehicle allowDamage false;
    _hs = nearestObjects[getMarkerPos _sp,["Land_Hospital_side2_F"],50] select 0;
    _vehicle setPosATL (_hs modelToWorld [-0.4,-4,12.65]);
    uisleep 0.6;
} else {
    _vehicle = createVehicle [(_vInfo select 2),_sp,[],0,"NONE"];
    waitUntil {!isNil "_vehicle" && {!isNull _vehicle}};
    _vehicle allowDamage false;
    _vehicle setPos _sp;
    _vehicle setVectorUp (surfaceNormal _sp);
    _vehicle setDir _dir;
};

// Fahrzeug wieder angreifbar machen
_vehicle allowDamage true;

// Fahrzeugschlüssel über das Netzwerk senden
[_vehicle] remoteExecCall ["life_fnc_addVehicle2Chain", _unit];

// Fahrzeug für den Spieler sperren
[_pid,_side,_vehicle,1] remoteExecCall ["TON_fnc_keyManagement",RSERV];
_vehicle lock 2;

// Fahrzeug umfärben
[_vehicle, _vInfo select 8] remoteExecCall ["life_fnc_colorVehicle", _unit];
_vehicle setVariable ["vehicle_info_owners",[[ _pid, _name]],true];
_vehicle setVariable ["dbInfo",[(_vInfo select 4),(_vInfo select 7),(_vInfo select 14)],true];
_vehicle disableTIEquipment true; // Keine Thermals

// Munition des Fahrzeugs leeren
[_vehicle] call life_fnc_clearVehicleAmmo;

// Wenn die Einstellung zum Speichern von virtuellen Gegenständen aktiviert ist
if (LIFE_SETTINGS(getNumber,"save_vehicle_virtualItems") isEqualTo 1) then {
    // Fahrzeugtrunk aktualisieren
    _vehicle setVariable ["Trunk",_trunk,true];

    // Wenn das Fahrzeug illegal ist
    if (_wasIllegal) then {
        private _refPoint = if (_sp isEqualType "") then {getMarkerPos _sp;} else {_sp;};
        
        private _distance = 100000;
        private "_location";

        // Überprüfen, ob das Fahrzeug in der Nähe einer Stadt oder eines Dorfes ist
        {
            private _tempLocation = nearestLocation [_refPoint, _x];
            private _tempDistance = _refPoint distance _tempLocation;
    
            if (_tempDistance < _distance) then {
                _location = _tempLocation;
                _distance = _tempDistance;
            };
            false
        } count ["NameCityCapital", "NameCity", "NameVillage"];
 
        _location = text _location;
        [1, "STR_NOTF_BlackListedVehicle", true, [_location,_name]] remoteExecCall ["life_fnc_broadcast", west];

        // Fahrzeug in die Blacklist eintragen
        _query = format ["updateVehicleBlacklist:%1:%2", _vid, _pid];
        [_query, 1] call HC_fnc_asyncCall;
    };   
} else {
    // Wenn die Einstellung zum Speichern von virtuellen Gegenständen deaktiviert ist
    _vehicle setVariable ["Trunk", [[], 0], true];
};

// Wenn die Einstellung zum Speichern von Treibstoff aktiviert ist
if (LIFE_SETTINGS(getNumber,"save_vehicle_fuel") isEqualTo 1) then {
    _vehicle setFuel (_vInfo select 11);
} else {
    _vehicle setFuel 1;
};

// Wenn das Fahrzeug Inventar hat und die Einstellung zum Speichern des Inventars aktiviert ist
if (!(_gear isEqualTo []) && (LIFE_SETTINGS(getNumber,"save_vehicle_inventory") isEqualTo 1)) then {
    // Gegenstände, Magazine, Waffen und Rucksäcke dem Fahrzeug hinzufügen
    _items = _gear select 0;
    _mags = _gear select 1;
    _weapons = _gear select 2;
    _backpacks = _gear select 3;

    for "_i" from 0 to ((count (_items select 0)) - 1) do {
        _vehicle addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
    };
    for "_i" from 0 to ((count (_mags select 0)) - 1) do {
        _vehicle addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
    };
    for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
        _vehicle addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
    };
    for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
        _vehicle addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
    };
};

// Wenn das Fahrzeug Schäden hat und die Einstellung zum Speichern von Schäden aktiviert ist
if (!(_damage isEqualTo []) && (LIFE_SETTINGS(getNumber,"save_vehicle_damage") isEqualTo 1)) then {
    // Schäden am Fahrzeug setzen
    _parts = getAllHitPointsDamage _vehicle;

    for "_i" from 0 to ((count _damage) - 1) do {
        _vehicle setHitPointDamage [format ["%1",((_parts select 0) select _i)],_damage select _i];
    };
};

// Animationen setzen, abhängig von Fahrzeugtyp und Fraktion
if ((_vInfo select 1) isEqualTo "civ" && (_vInfo select 2) isEqualTo "B_Heli_Light_01_F" && !((_vInfo select 8) isEqualTo 13)) then {
    [_vehicle,"civ_littlebird",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};

if ((_vInfo select 1) isEqualTo "cop" && ((_vInfo select 2)) in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F","C_Hatchback_01_sport_F","B_Heli_Light_01_F","B_Heli_Transport_01_F"]) then {
    [_vehicle,"cop_offroad",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};

if ((_vInfo select 1) isEqualTo "med" && (_vInfo select 2) isEqualTo "C_Offroad_01_F") then {
    [_vehicle,"med_offroad",true] remoteExecCall ["life_fnc_vehicleAnimate",_unit];
};

// Broadcast-Nachricht je nach Versicherungsstatus
if ((_vInfo select 14) isEqualTo 1) then {
    [1,"Ihr Fahrzeug ist verfügbar und versichert!"] remoteExecCall ["life_fnc_broadcast",_unit];
} else {
    [1,"Ihr Fahrzeug ist verfügbar, aber nicht versichert!"] remoteExecCall ["life_fnc_broadcast",_unit];
};

// Benutzerdefinierte Broadcast-Nachricht senden
[1, _spawntext] remoteExecCall ["life_fnc_broadcast", _unit];

// Verwendetes Fahrzeug aus der Liste entfernen
serv_sv_use deleteAt _servIndex;
