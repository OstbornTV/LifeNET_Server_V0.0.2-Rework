#include "..\..\script_macros.hpp"
/*
    File: fn_receiveItem.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Receive an item from a player.

    Parameters:
        _receivingUnit: Die Einheit, die das Element empfängt.
        _receivedValue: Der Wert des empfangenen Elements.
        _itemName: Der Name des empfangenen Elements.
        _giver: Die Einheit, die das Element gibt.
*/

private ["_receivingUnit", "_receivedValue", "_itemName", "_giver", "_weightDiff"];

// Parameter zuweisen
_receivingUnit = _this select 0;
if !(_receivingUnit isEqualTo player) exitWith {};
_receivedValue = _this select 1;
_itemName = _this select 2;
_giver = _this select 3;

// Gewichtsdifferenz berechnen
_weightDiff = [_itemName, (parseNumber _receivedValue), life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;

// Überprüfen, ob das Gewicht gültig ist
if (!(_weightDiff isEqualTo (parseNumber _receivedValue))) then {
    // Überprüfen, ob das Item im Inventar des Gebers ist
    if ([true, _itemName, _weightDiff] call life_fnc_handleInv) then {
        hint format [localize "STR_MISC_TooMuch_3", _giver getVariable ["realname", name _giver], _receivedValue, _weightDiff, ((parseNumber _receivedValue) - _weightDiff)];
        [_giver, _itemName, str((parseNumber _receivedValue) - _weightDiff), _receivingUnit] remoteExecCall ["life_fnc_giveDiff", _giver];
    } else {
        // Wenn nicht genug Platz im Inventar des Empfängers ist, die Differenz zurückgeben
        [_giver, _itemName, _receivedValue, _receivingUnit, false] remoteExecCall ["life_fnc_giveDiff", _giver];
    };
} else {
    // Wenn das Item erfolgreich empfangen wurde
    if ([true, _itemName, (parseNumber _receivedValue)] call life_fnc_handleInv) then {
        // Benachrichtigung über das erhaltene Item
        private _itemType = M_CONFIG(getText, "VirtualItems", _itemName, "displayName");
        hint format [localize "STR_NOTF_GivenItem", _giver getVariable ["realname", name _giver], _receivedValue, _itemType];
    } else {
        // Wenn nicht genug Platz im Inventar des Empfängers ist, die Differenz zurückgeben
        [_giver, _itemName, _receivedValue, _receivingUnit, false] remoteExecCall ["life_fnc_giveDiff", _giver];
    };
};
