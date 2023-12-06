#include "\life_server\script_macros.hpp"
/*
    File: fn_removeGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Entfernt die Gang aus der Datenbank
*/
params [
    ["_group", grpNull, [grpNull]]
];

// Wenn die Gruppe ungültig ist, beende die Funktion
if (isNull _group) exitWith {};

// Hole die Gang-ID aus den Gruppenvariablen
private _groupID = _group getVariable ["gang_id", -1];

// Wenn die Gang-ID ungültig ist, beende die Funktion
if (_groupID isEqualTo -1) exitWith {};

// Setze den Besitzer der Gang auf nil und führe die asynchrone Datenbanklöschung durch
_group setVariable ["gang_owner", nil, true];
[format ["deleteGang:%1", _groupID], 1] call DB_fnc_asyncCall;

// Informiere über die Auflösung der Gang und warte 5 Sekunden, bevor die Gruppe gelöscht wird
[_group] remoteExecCall ["life_fnc_gangDisbanded", (units _group)];
uiSleep 5;
deleteGroup _group;
