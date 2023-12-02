#include "..\..\script_macros.hpp"
/*
    File: fn_handleInv.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Diese Funktion wird verwendet, um Elemente zum Inventar hinzuzufügen oder zu entfernen.

    Parameter:
    _math: Ein boolescher Wert, der angibt, ob Elemente hinzugefügt (true) oder entfernt (false) werden sollen.
    _item: Der Name des Elements, das hinzugefügt oder entfernt werden soll.
    _num: Die Anzahl der hinzuzufügenden oder zu entfernenden Elemente.
    _return: Ein boolescher Wert, der angibt, ob die Aktion erfolgreich war oder nicht.
    _var: Der Name der Variablen, die den aktuellen Bestand des Elements im Inventar repräsentiert.
    _weight: Das Gewicht des Elements.
    _value: Der aktuelle Bestand des Elements im Inventar.
    _diff: Die Differenz zwischen dem aktuellen Gewicht und dem maximalen Gewicht im Inventar.

    Rückgabewert:
    Ein boolescher Wert, der angibt, ob die Aktion erfolgreich war oder nicht.
*/

private ["_math","_item","_num","_return","_var","_weight","_value","_diff"];

// _math: Ein boolescher Wert, der angibt, ob Elemente hinzugefügt (true) oder entfernt (false) werden sollen.
_math = [_this, 0, false, [false]] call BIS_fnc_param;

// _item: Der Name des Elements, das hinzugefügt oder entfernt werden soll.
_item = [_this, 1, "", [""]] call BIS_fnc_param;

// _num: Die Anzahl der hinzuzufügenden oder zu entfernenden Elemente.
_num = [_this, 2, 0, [0]] call BIS_fnc_param;

// Überprüfen, ob _item leer ist oder _num gleich 0 ist
if (_item isEqualTo "" || _num isEqualTo 0) exitWith {false};

// _var: Der Name der Variablen, die den aktuellen Bestand des Elements im Inventar repräsentiert.
_var = ITEM_VARNAME(_item);

// Wenn _math true ist (Elemente hinzufügen)
if (_math) then {
    // _diff: Die Differenz zwischen dem aktuellen Gewicht und dem maximalen Gewicht im Inventar.
    _diff = [_item, _num, life_carryWeight, life_maxWeight] call life_fnc_calWeightDiff;
    _num = _diff;

    // Wenn _num kleiner oder gleich 0 ist, war die Aktion nicht erfolgreich
    if (_num <= 0) exitWith {false};
};

// _weight: Das Gewicht des Elements.
_weight = ([_item] call life_fnc_itemWeight) * _num;

// _value: Der aktuelle Bestand des Elements im Inventar.
_value = ITEM_VALUE(_item);

// Wenn _math true ist (Elemente hinzufügen)
if (_math) then {
    // Überprüfen, ob das Hinzufügen das maximale Gewicht im Inventar nicht überschreitet
    if ((life_carryWeight + _weight) <= life_maxWeight) then {
        // Den aktuellen Bestand des Elements im Inventar aktualisieren
        missionNamespace setVariable [_var, (_value + _num)];

        // Überprüfen, ob der aktuelle Bestand größer als der vorherige Bestand ist
        if ((missionNamespace getVariable _var) > _value) then {
            // Das Gesamtgewicht im Inventar aktualisieren
            life_carryWeight = life_carryWeight + _weight;
            _return = true; // Die Aktion war erfolgreich
        } else {
            _return = false; // Die Aktion war nicht erfolgreich
        };
    } else {
        _return = false; // Die Aktion war nicht erfolgreich, da das maximale Gewicht überschritten wurde
    };
} else {
    // Wenn _math false ist (Elemente entfernen)
    // Überprüfen, ob der Bestand nach dem Entfernen nicht negativ wird
    if ((_value - _num) < 0) then {
        _return = false; // Die Aktion war nicht erfolgreich
    } else {
        // Den aktuellen Bestand des Elements im Inventar aktualisieren
        missionNamespace setVariable [_var, (_value - _num)];

        // Überprüfen, ob der aktuelle Bestand kleiner als der vorherige Bestand ist
        if ((missionNamespace getVariable _var) < _value) then {
            // Das Gesamtgewicht im Inventar aktualisieren
            life_carryWeight = life_carryWeight - _weight;
            _return = true; // Die Aktion war erfolgreich
        } else {
            _return = false; // Die Aktion war nicht erfolgreich
        };
    };
};

// Den Erfolg oder Misserfolg der Aktion zurückgeben
_return;
