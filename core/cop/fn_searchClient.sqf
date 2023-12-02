#include "..\..\script_macros.hpp"
/*
    File: fn_searchClient.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Searches the player and returns information back to the player.
*/

// Parameter definieren
params [
    ["_cop", objNull, [objNull]]
];

// Überprüfen, ob der _cop ungültig ist
if (isNull _cop) exitWith {};

// Leeres Array für Inventar und Variable für Räuberstatus initialisieren
private _inv = [];
private _robber = false;

// Illegale Gegenstände im Inventar überprüfen
{
    private _var = configName(_x);
    private _val = ITEM_VALUE(_var);
    if (_val > 0) then {
        // Gegenstand und Wert zum Inventar hinzufügen
        _inv pushBack [_var, _val];
        [false, _var, _val] call life_fnc_handleInv;
    };
    true
} count ("getNumber(_x >> 'illegal') isEqualTo 1" configClasses (missionConfigFile >> "VirtualItems"));

// Überprüfen, ob ATM-Nutzung deaktiviert ist
if (!life_use_atm) then {
    // Wenn die ATM-Nutzung deaktiviert ist, das Bargeld auf 0 setzen und Räuberstatus auf true setzen
    CASH = 0;
    _robber = true;
};

// Remote-Execution der life_fnc_copSearch Funktion mit den gesammelten Informationen
[player, _inv, _robber] remoteExec ["life_fnc_copSearch", _cop];
