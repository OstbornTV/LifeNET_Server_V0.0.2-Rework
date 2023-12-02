#include "..\..\script_macros.hpp"
/*
    File: fn_vehInvSearch.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Searches the vehicle for illegal items.
*/

// Überprüfe, ob das Fahrzeugobjekt gültig ist und zu den erlaubten Typen gehört
private _vehicle = cursorObject;
private _typeList = ["Air", "Ship", "LandVehicle"];

if (isNull _vehicle || {!(KINDOF_ARRAY(_vehicle, _typeList))}) exitWith {};

// Holen Sie sich die Fahrzeuginformationen aus den Trunk-Variablen
private _vehicleInfo = _vehicle getVariable ["Trunk", []];
if (_vehicleInfo isEqualTo []) exitWith {hint localize "STR_Cop_VehEmpty"};
_vehicleInfo params ["_items"];

// Initialisiere Variablen für die Gesamtmenge und den illegalen Wert
private _value = 0;
private _illegalValue = 0;

// Iteriere durch die Fahrzeuggegenstände und berechne den illegalen Wert
{
    _x params ["_var", "_val"];
    // Überprüfe, ob der Gegenstand illegal ist
    private _isIllegalItem = M_CONFIG(getNumber, "VirtualItems", _var, "illegal");
    if (_isIllegalItem isEqualTo 1) then {
        // Holen Sie sich den illegalen Preis des Gegenstands
        private _illegalPrice = M_CONFIG(getNumber, "VirtualItems", _var, "sellPrice");
        // Überprüfe, ob der Gegenstand als verarbeiteter Gegenstand konfiguriert ist
        if !(isNull (missionConfigFile >> "VirtualItems" >> _var >> "processedItem")) then {
            // Wenn ja, aktualisieren Sie den illegalen Preis basierend auf dem verarbeiteten Gegenstand
            private _illegalItemProcessed = M_CONFIG(getText, "VirtualItems", _var, "processedItem");
            _illegalPrice = M_CONFIG(getNumber, "VirtualItems", _illegalItemProcessed, "sellPrice");
        };

        // Berechne den illegalen Wert basierend auf der Menge und dem illegalen Preis
        _illegalValue = _illegalValue + round(_val * _illegalPrice / 2);
    };
    true
} count _items;

// Überprüfe, ob es illegale Gegenstände gibt
if (_illegalValue > 0) then {
    // Sende Rundfunknachricht über illegal gefundene Gegenstände
    [0, "STR_NOTF_VehContraband", true, [[_illegalValue] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
    // Fügen Sie den illegalen Wert zur Bank hinzu und aktualisieren Sie das Client-UI
    BANK = BANK + _illegalValue;
    [1] call SOCK_fnc_updatePartial;
    // Leeren Sie den Trunk des Fahrzeugs
    _vehicle setVariable ["Trunk", [[], 0], true];
} else {
    // Zeige eine Meldung an, wenn keine illegalen Gegenstände gefunden wurden
    hint localize "STR_Cop_NoIllegalVeh";
};