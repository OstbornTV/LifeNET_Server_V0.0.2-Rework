#include "\life_server\script_macros.hpp"
/*
    File : fn_fetchPlayerHouses.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: NiiRoZz

    Description:
    1. Ruft alle Häuser des Spielers ab und richtet sie ein.
    2. Ruft alle Container des Spielers ab und richtet sie ein.
*/

params [
    ["_uid", "", [""]]
];

// Überprüfen, ob _uid leer ist
if (_uid isEqualTo "") exitWith {};

// Abfrage für die Container des Spielers
private _query = format ["selectContainers:%1", _uid];
private _containers = [_query, 2, true] call DB_fnc_asyncCall;

// Initialisiere eine leere Liste für die Container der Häuser
private _containerss = [];

{
    // Extrahiere die Position, Richtung und Eigenschaften aus der Container-Datenbankantwort
    _position = call compile format ["%1", _x select 1];
    _direction = call compile format ["%1", _x select 5];
    _trunk = call compile format ["%1", (_x select 3)];
    _gear = call compile format ["%1", (_x select 4)];

    // Erstelle einen neuen Container
    _container = createVehicle [_x select 2, [0, 0, 999], [], 0, "NONE"];

    // Warte, bis der Container erstellt wurde
    waitUntil {!isNil "_container" && {!isNull _container}};

    // Aktualisiere die Liste der Container für das Haus
    _containerss = _house getVariable ["containers", []];
    _containerss pushBack _container;

    // Setze verschiedene Eigenschaften für den Container
    _container allowDamage false;
    _container setPosATL _position;
    _container setVectorDirAndUp _direction;

    //Fix position for more accurate positioning
    _posX = _position select 0;
    _posY = _position select 1;
    _posZ = _position select 2;
    _currentPos = getPosATL _container;
    _fixX = (_currentPos select 0) - _posX;
    _fixY = (_currentPos select 1) - _posY;
    _fixZ = (_currentPos select 2) - _posZ;
    
    _container setPosATL [(_posX - _fixX), (_posY - _fixY), (_posZ - _fixZ)];

    // Fixiere die Position für eine genauere Positionierung
    _container setPosATL [(_position select 0), (_position select 1), (_position select 2)];

    // Setze die Richtung erneut
    _container setVectorDirAndUp _direction;

    // Setze Eigenschaften des Containers in seinen Variablen
    _container setVariable ["Trunk", _trunk, true];
    _container setVariable ["container_owner", [_x select 0], true];
    _container setVariable ["container_id", _x select 6, true];

    // Leere das Inventar des Containers
    clearWeaponCargoGlobal _container;
    clearItemCargoGlobal _container;
    clearMagazineCargoGlobal _container;
    clearBackpackCargoGlobal _container;

    // Fülle das Inventar des Containers basierend auf den geladenen Daten
    if (count _gear > 0) then {
        _items = _gear select 0;
        _mags = _gear select 1;
        _weapons = _gear select 2;
        _backpacks = _gear select 3;

        // Füge Gegenstände hinzu
        for "_i" from 0 to ((count (_items select 0)) - 1) do {
            _container addItemCargoGlobal [((_items select 0) select _i), ((_items select 1) select _i)];
        };

        // Füge Magazine hinzu
        for "_i" from 0 to ((count (_mags select 0)) - 1) do {
            _container addMagazineCargoGlobal [((_mags select 0) select _i), ((_mags select 1) select _i)];
        };

        // Füge Waffen hinzu
        for "_i" from 0 to ((count (_weapons select 0)) - 1) do {
            _container addWeaponCargoGlobal [((_weapons select 0) select _i), ((_weapons select 1) select _i)];
        };

        // Füge Rucksäcke hinzu
        for "_i" from 0 to ((count (_backpacks select 0)) - 1) do {
            _container addBackpackCargoGlobal [((_backpacks select 0) select _i), ((_backpacks select 1) select _i)];
        };
    }

    // Aktualisiere die Liste der Container für das Haus
    _house setVariable ["containers", _containerss, true];

} forEach _containers;

// Abfrage für die Positionen der Häuser des Spielers
_query = format ["selectHousePositions:%1", _uid];
private _houses = [_query, 2, true] call DB_fnc_asyncCall;

// Initialisiere eine leere Liste für die Rückgabewerte
_return = [];

{
    // Extrahiere die Position des Hauses
    _pos = call compile format ["%1", _x select 1];

    // Finde das nächste Objekt vom Typ "House" zur Position
    _house = nearestObject [_pos, "House"];
    _house allowDamage false;

    // Füge die Position zum Rückgabewert hinzu
    _return pushBack [_x select 1];

} forEach _houses;

// Setze die Variable für die Häuser im Missionsnamenraum
missionNamespace setVariable [format ["houses_%1", _uid], _return];
