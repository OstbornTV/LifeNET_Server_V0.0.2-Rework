/*
    File: fn_hideObj.sqf

    Author: Daniel Stuart and NiiRoZz

    Description:
    Verbirgt ein Objekt vor allen Spielern

    Verwendung:
    _id = Der Besitzer des Spielers
    [_object] remoteExecCall ["life_fnc_hideObj",-_id];
*/
params [
    ["_object", objNull, [objNull]]
];

// Überprüfen, ob das übergebene Objekt gültig ist
if (isNull _object) exitWith {};

// Objekt ausblenden
_object hideObject true;
