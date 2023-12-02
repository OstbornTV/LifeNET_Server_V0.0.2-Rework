#include "..\..\script_macros.hpp"
/*
    File: fn_containerInvSearch.sqf
    Author: NiiRoZz
    Inspired : Bryan "Tonic" Boardwine
    
    Description:
    Searches the container for illegal items.
*/

// Parameter definieren
params [
    ["_container", objNull, [objNull]]
];

// Überprüfen, ob der Container gültig ist
if (isNull _container) exitWith {};

// Container-Informationen abrufen
private _containerInfo = _container getVariable ["Trunk",[]];

// Überprüfen, ob der Container leer ist
if (_containerInfo isEqualTo []) exitWith {hint localize "STR_Cop_ContainerEmpty"};

// Container-Informationen extrahieren
_containerInfo params ["_items"];

// Variable für den illegalen Wert initialisieren
private _illegalValue = 0;

// Durchsuche die Items im Container
{
    // Parameter für jedes Item extrahieren
    _x params ["_var", "_val"];

    // Überprüfen, ob das Item illegal ist
    private _isIllegalItem = M_CONFIG(getNumber,"VirtualItems",_var,"illegal");
    if (_isIllegalItem isEqualTo 1) then {
        // Verkaufspreis für illegales Item abrufen
        private _illegalPrice = M_CONFIG(getNumber,"VirtualItems",_var,"sellPrice");

        // Überprüfen, ob das Item bereits verarbeitet wurde
        if !(isNull (missionConfigFile >> "VirtualItems" >> _var >> "processedItem")) then {
            private _illegalItemProcessed = M_CONFIG(getText,"VirtualItems",_var,"processedItem");
            _illegalPrice = M_CONFIG(getNumber,"VirtualItems",_illegalItemProcessed,"sellPrice");
        };

        // Illegalen Wert aktualisieren
        _illegalValue = _illegalValue + (round(_val * _illegalPrice / 2));
    };
    true
} count _items;

// Überprüfen, ob illegale Items gefunden wurden
if (_illegalValue > 0) then {
    // Benachrichtigung über gefundene illegale Gegenstände
    [0,"STR_NOTF_ContainerContraband",true,[[_illegalValue] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",RCLIENT];

    // Bankguthaben aktualisieren
    BANK = BANK + _illegalValue;

    // Server über Teile des Updates informieren
    [1] call SOCK_fnc_updatePartial;

    // Container-Inhalt löschen und speichern
    _container setVariable ["Trunk",[[],0],true];
    [_container] remoteExecCall ["TON_fnc_updateHouseTrunk",2];
} else {
    // Hinweis, dass keine illegalen Items gefunden wurden
    hint localize "STR_Cop_NoIllegalContainer";
};
