#include "..\..\script_macros.hpp"
/*
    File: fn_seizeClient.sqf
    Author: Daniel "Skalicon" Larusso

    Description:
    Entfernt die Waffen, Ausrüstung und Munition des Spielers auf der Client-Seite
*/

// Ausnahmen für das Entfernen definieren
private _exempt = LIFE_SETTINGS(getArray, "seize_exempt");
private _headgear = LIFE_SETTINGS(getArray, "seize_headgear");
private _vest = LIFE_SETTINGS(getArray, "seize_vest");
private _uniform = LIFE_SETTINGS(getArray, "seize_uniform");

// Funktion zum Entfernen von Gegenständen definieren
private _removeItems = {
    private ["_item", "_container"];
    _item = _this select 0;
    _container = _this select 1;

    // Überprüfen, ob das Element nicht ausgenommen ist und entfernen
    if !(_item in _exempt) then {
        player removeItem _item;
    };
};

// Waffen entfernen
{[_x, weapons player] call _removeItems} forEach weapons player;

// Ausrüstung entfernen
{[_x, uniformItems player] call _removeItems} forEach uniformItems player;
{[_x, vestItems player] call _removeItems} forEach vestItems player;
{[_x, backpackItems player] call _removeItems} forEach backpackItems player;

// Magazine entfernen
{[_x, magazines player] call _removeItems} forEach magazines player;

// Überprüfen und Uniform, Weste und Kopfbedeckung entfernen, wenn sie ausgenommen sind
if (uniform player in _uniform) then {
    removeUniform player;
};
if (vest player in _vest) then {
    removeVest player;
};
if (headgear player in _headgear) then {
    removeHeadgear player;
};

// SOCK Update anfordern und Benachrichtigung anzeigen
[] call SOCK_fnc_updateRequest;
titleText[localize "STR_NOTF_SeizeIllegals", "PLAIN"];
