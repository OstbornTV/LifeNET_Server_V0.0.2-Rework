/*
    File : fn_updateHouseContainers.sqf
    Author: NiiRoZz
    Description:
    Aktualisiert das Inventar "i" im Container
*/

params [
    ["_container", objNull, [objNull]]
];

// Beende mit einer Meldung, wenn der Container ungültig ist
if (isNull _container) exitWith {};

// Ermittle die Container-ID aus der Container-Variable
private _containerID = _container getVariable ["container_id", -1];

// Überprüfe, ob die Container-ID ungültig ist
if (_containerID isEqualTo -1) exitWith {};

// Sammle die Inhalte des Containers
private _vehItems = getItemCargo _container;
private _vehMags = getMagazineCargo _container;
private _vehWeapons = getWeaponCargo _container;
private _vehBackpacks = getBackpackCargo _container;

// Setze die gesamten Inhalte in ein Array
private _cargo = [_vehItems, _vehMags, _vehWeapons, _vehBackpacks];

// Erstelle die Datenbankabfrage
private _query = format ["updateContainer:%1:%2", _cargo, _containerID];

// Führe die Datenbankabfrage asynchron aus
[_query, 1] call DB_fnc_asyncCall;
