/*
    File : fn_updateHouseTrunk.sqf
    Author: NiiRoZz
    Description:
    Aktualisiert das Inventar "z" im Container
*/

params [
    ["_container", objNull, [objNull]]
];

// Beende mit einer Meldung, wenn der Container ungültig ist
if (isNull _container) exitWith {};

// Erhalte die Trunk-Daten aus der Container-Variable
private _trunkData = _container getVariable ["Trunk", [[], 0]];

// Erhalte die Container-ID aus der Container-Variable
private _containerID = _container getVariable ["container_id", -1];

// Überprüfe, ob die Container-ID ungültig ist
if (_containerID isEqualTo -1) exitWith {};

// Erstelle die Datenbankabfrage
private _query = format ["updateHouseTrunk:%1:%2", _trunkData, _containerID];

// Führe die Datenbankabfrage asynchron aus
[_query, 1] call DB_fnc_asyncCall;
