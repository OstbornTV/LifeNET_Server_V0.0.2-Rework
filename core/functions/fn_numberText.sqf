/*
    File: fn_numberText.sqf
    Author: Karel Moricky

    Description:
    Konvertiert eine Zahl in einen String (vermeidet wissenschaftliche Notation).

    Parameter:
    _this: ZAHL

    Returns:
    STRING
*/
private ["_number","_mod","_digits","_digitsCount","_modBase","_numberText"];

// Parameter überprüfen und initialisieren
_number = [_this, 0, 0, [0]] call bis_fnc_param;
_mod = [_this, 1, 3, [0]] call bis_fnc_param;

_digits = _number call bis_fnc_numberDigits;
_digitsCount = count _digits - 1;

_modBase = _digitsCount % _mod;
_numberText = "";

// Durchlaufe die Ziffern der Zahl und erstelle den Text
{
    _numberText = _numberText + str _x;
    
    // Füge ein Komma hinzu, wenn die Anzahl der Ziffern durch _mod teilbar ist
    // und die aktuelle Ziffer nicht die letzte ist
    if ((_foreachindex - _modBase) % (_mod) isEqualTo 0 && !(_foreachindex isEqualTo _digitsCount)) then {
        _numberText = _numberText + ",";
    };
} forEach _digits;

// Rückgabe des erstellten Texts
_numberText;
