#include "..\..\script_macros.hpp"
/*
    File: fn_calWeightDiff.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Berechnet Gewichtsdifferenzen im _cWeight (aktuelles Gewicht) gegenüber dem _mWeight (maximales Gewicht).
    Vielzwecksystem für diese Life-Mission.
*/
if !( // Überprüfe, ob alle erforderlichen Parameter vorhanden sind
    params [
        ["_item","",[""]],
        ["_value",-1,[0]],
        ["_cWeight",-1,[0]],
        ["_mWeight",-1,[0]]
    ]
) exitWith {-1}; // Wenn nicht, beende das Skript mit einem Fehlerwert (-1)

private _iWeight = [_item] call life_fnc_itemWeight; // Berechne das Gewicht des Gegenstands mit Hilfe einer Funktion life_fnc_itemWeight
if (_iWeight isEqualTo 0) exitWith {_value}; // Wenn das Gewicht des Gegenstands gleich null ist, beende das Skript mit dem angegebenen Standardwert (_value)

(floor ((_mWeight - _cWeight) / _iWeight)) min _value; // Berechne die Gewichtsdifferenz und begrenze sie auf den angegebenen Standardwert (_value)