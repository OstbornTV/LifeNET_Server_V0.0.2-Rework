#include "..\..\script_macros.hpp"
/*
    File: fn_copSearch.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Returns information on the search.
*/

// Markiert, dass keine Aktion ausgeführt wird
life_action_inUse = false;

params [
    ["_civ", objNull, [objNull]], // Die durchsuchte Zivilperson
    ["_invs", [], [[]]], // Das Inventar der Zivilperson
    ["_robber", false, [false]] // Gibt an, ob die Zivilperson ein Räuber ist
];

if (isNull _civ) exitWith {};

private _inv = "";
if (count _invs > 0) then {
    private _illegal = 0;

    // Für jedes Element im Inventar der Zivilperson
    {
        _x params ["_var", "_count"]; // Element und Anzahl

        private _displayName = M_CONFIG(getText, "VirtualItems", _var, "displayName");
        _inv = _inv + format ["%1 %2<br/>", _count, _displayName]; // Anzahl und Anzeigename
        private _price = M_CONFIG(getNumber, "VirtualItems", _var, "sellPrice");

        // Wenn das Element illegal ist
        if (_price isEqualTo -1) then {
            private _processed = M_CONFIG(getText, "VirtualItems", _var, "processedItem");
            _price = M_CONFIG(getNumber, "VirtualItems", _processed, "sellPrice");
        };

        // Wenn das Element einen Preis hat
        if !(_price isEqualTo -1) then {
            _illegal = _illegal + (_count * _price); // Illegalen Wert aktualisieren
        };
        true
    } count _invs;

    // Wenn der illegale Wert über 6000 liegt
    if (_illegal > 6000) then {
        // Polizei informieren
        if (life_HC_isActive) then {
            [getPlayerUID _civ, _civ getVariable ["realname", name _civ], "482"] remoteExecCall ["HC_fnc_wantedAdd", HC_Life];
        } else {
            [getPlayerUID _civ, _civ getVariable ["realname", name _civ], "482"] remoteExecCall ["life_fnc_wantedAdd", RSERV];
        };
    };

    // Polizei informieren
    if (life_HC_isActive) then {
        [getPlayerUID _civ, _civ getVariable ["realname", name _civ], "481"] remoteExecCall ["HC_fnc_wantedAdd", HC_Life];
    } else {
        [getPlayerUID _civ, _civ getVariable ["realname", name _civ], "481"] remoteExecCall ["life_fnc_wantedAdd", RSERV];
    };

    // Broadcast an die westliche Fraktion über illegale Gegenstände
    [0, "STR_Cop_Contraband", true, [(_civ getVariable ["realname", name _civ]), [_illegal] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", west];
} else {
    _inv = localize "STR_Cop_NoIllegal"; // Keine illegalen Gegenstände im Inventar
};

// Wenn die Zivilperson nicht mehr lebt oder der Spieler zu weit entfernt ist
if (!alive _civ || {player distance _civ > 5}) exitWith {
    hint format [localize "STR_Cop_CouldntSearch", _civ getVariable ["realname", name _civ]];
};

// Text-Hinweis mit den Suchergebnissen und möglicher Räuber-Mitteilung
hint parseText format ["<t color='#FF0000'><t size='2'>%1</t></t><br/><t color='#FFD700'><t size='1.5'><br/>" + (localize "STR_Cop_IllegalItems") + "</t></t><br/>%2<br/><br/><br/><br/><t color='#FF0000'>%3</t>",
    (_civ getVariable ["realname", name _civ]), _inv, ["", "Robbed the bank"] select _robber];

// Wenn es sich um einen Räuber handelt, dann den Räuber broadcasten
if (_robber) then {
    [0, "STR_Cop_Robber", true, [_civ getVariable ["realname", name _civ]]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
};
