/*
    File: fn_simDisable.sqf
    Author:

    Description:
    Diese Funktion ermöglicht das Aktivieren oder Deaktivieren der Simulation für ein Objekt.
*/

// Deklaration der lokalen Variablen
private ["_obj","_bool"];

// Parameter extrahieren (Objekt und boolscher Wert)
_obj = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_bool = [_this, 1, false, [false]] call BIS_fnc_param;

// Überprüfen, ob das Objekt nicht null ist
if (isNull _obj) exitWith {};

// Simulation des Objekts entsprechend des boolschen Werts aktivieren oder deaktivieren
_obj enableSimulation _bool;
