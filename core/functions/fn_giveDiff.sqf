#include "..\..\script_macros.hpp"
/*
    File: fn_giveDiff.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: OsbornTV

    Description:
    Diese Funktion behandelt die Differenz beim Geben von Gegenständen zwischen zwei Einheiten.

    Parameter:
    _unit: Die Einheit, die den Gegenstand gibt (Absender).
    _item: Der Gegenstand, der übergeben wird.
    _val: Die Menge des Gegenstands, die übergeben wird.
    _from: Die Einheit, die den Gegenstand empfängt.
    _bool: Ein optionaler Parameter, der angibt, ob es sich um einen "TooMuch"-Fall handelt.

    Rückgabewert:
    Die Funktion gibt true zurück, wenn die Operation erfolgreich ist, andernfalls false.
*/

private ["_unit","_item","_val","_from","_bool"];

_unit = _this select 0;

// Überprüfen, ob die Einheit mit dem Spieler übereinstimmt
if !(_unit isEqualTo player) exitWith {};

_item = _this select 1;
_val = _this select 2;
_from = _this select 3;

// Überprüfen, ob _bool vorhanden ist und true ist, ansonsten false
_bool = if (count _this > 4) then {true} else {false};

// Ermitteln des Anzeigetyps (displayName) des Gegenstands
_type = M_CONFIG(getText, "VirtualItems", _item, "displayName");

if (_bool) then {
    // Wenn true, handleInv aufrufen und eine Meldung für "TooMuch" anzeigen
    if ([true, _item, (parseNumber _val)] call life_fnc_handleInv) then {
        hint format [localize "STR_MISC_TooMuch", _from getVariable ["realname", name _from], _val, _type];
    };
} else {
    // Wenn false, handleInv aufrufen und eine andere Meldung für "TooMuch" anzeigen
    if ([true, _item, (parseNumber _val)] call life_fnc_handleInv) then {
        hint format [localize "STR_MISC_TooMuch_2", _from getVariable ["realname", name _from], _val, _type];
    };
};
