/*
    File: fn_animSync.sqf
    Author: Unbekannt

    Beschreibung:
    Dieses Skript synchronisiert die Animation eines Einheit (_unit) mit der angegebenen Animation (_anim).

    Parameter:
    - _unit: Die Einheit, deren Animation synchronisiert werden soll.
    - _anim: Die Animation, mit der die Einheit synchronisiert werden soll.
    - _cancelOwner: Ein optionaler Parameter zum Abbrechen der Animation, wenn die Einheit lokal ist (lokal _unit). Standardmäßig auf false gesetzt.

    Hinweis: Das Skript verwendet die BIS-Funktionen BIS_fnc_param, um sicherzustellen, dass die Parameter korrekt formatiert sind.
*/

private ["_unit","_anim"];
_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param; // Extrahiere und formatiere den _unit-Parameter
_anim = [_this,1,"",[""]] call BIS_fnc_param; // Extrahiere und formatiere den _anim-Parameter
_cancelOwner = [_this,2,false,[true]] call BIS_fnc_param; // Extrahiere und formatiere den _cancelOwner-Parameter

// Überprüfe, ob _unit null ist oder (lokal _unit) und _cancelOwner auf true gesetzt ist, dann beende das Skript
if (isNull _unit || {(local _unit && _cancelOwner)}) exitWith {};

// Setze die Animation der Einheit auf die angegebene Animation (_anim)
_unit switchMove _anim;
