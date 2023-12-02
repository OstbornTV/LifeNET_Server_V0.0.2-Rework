#include "..\..\script_macros.hpp"
/*
    File: fn_receiveMoney.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Receives money

    Parameters:
        _receivingUnit: Der Einheit, die das Geld empfängt.
        _receivedValue: Der Betrag, der empfangen wird.
        _giver: Die Einheit, die das Geld gibt.
*/

params [
    ["_receivingUnit", objNull, [objNull]],
    ["_receivedValue", "", [""]],
    ["_giver", objNull, [objNull]]
];

// Überprüfung auf ungültige Parameter oder besondere Fälle
if (isNull _receivingUnit || isNull _giver || _receivedValue isEqualTo "") exitWith {};
if !(player isEqualTo _receivingUnit) exitWith {};
if (!([_receivedValue] call life_util_fnc_isNumber)) exitWith {};
if (_receivingUnit == _giver) exitWith {}; // Vermeide Selbsttransaktion.

// Benachrichtigung über den erhaltenden Betrag
hint format [localize "STR_NOTF_GivenMoney", _giver getVariable ["realname", name _giver], [(parseNumber (_receivedValue))] call life_fnc_numberText];

// Geld hinzufügen und Datenbank aktualisieren
CASH = CASH + parseNumber(_receivedValue);
[0] call SOCK_fnc_updatePartial;
