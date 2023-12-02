#include "..\..\script_macros.hpp"
/*
    File: fn_inventoryOpened.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Für die Übergangszeit blockiert es den Spieler davon, den Rucksack einer anderen Person zu öffnen.
*/
params [
    ["_unit", objNull, [objNull]], // Optionaler Parameter für die Einheit (Standardwert: objNull)
    ["_container", objNull, [objNull]], // Optionaler Parameter für den Container (Standardwert: objNull)
    ["_secContainer", objNull, [objNull]] // Optionaler Parameter für den Sekundärcontainer (Standardwert: objNull)
];

scopeName "main"; // Definiert den Scope-Namen als "main"

// Liste von Container-Typen
private _list = ["LandVehicle", "Ship", "Air"];

{
    if (isNull _x) then {false breakOut "main"}; // Wenn _x null ist, verlasse den "main"-Scope

    private _containerType = typeOf _x; // Typ des Containers

    // Überprüfe, ob der Container ein Rucksack ist
    if (FETCH_CONFIG2(getNumber, "CfgVehicles", _containerType, "isBackpack") isEqualTo 1) exitWith {
        hint localize "STR_MISC_Backpack"; // Zeige eine Meldung an, dass es ein Rucksack ist
        true breakOut "main"; // Verlasse den "main"-Scope
    };

    // Überprüfe, ob der Container ein bestimmter Typ ist (z.B. "Box_IND_Grenades_F" oder "B_supplyCrate_F")
    if (_containerType in ["Box_IND_Grenades_F", "B_supplyCrate_F"]) exitWith {
        private _house = nearestObject [player, "House"]; // Finde das nächstgelegene Haus
        // Überprüfe, ob das Haus nicht in life_vehicles ist und gesperrt (locked) ist
        if (!(_house in life_vehicles) && {_house getVariable ["locked",true]}) exitWith {
            hint localize "STR_House_ContainerDeny"; // Zeige eine Meldung an, dass der Container gesperrt ist
            true breakOut "main"; // Verlasse den "main"-Scope
        };
    };

    // Überprüfe, ob der Container-Typ in der Liste _list ist
    if (KINDOF_ARRAY(_x, _list)) exitWith {
        // Überprüfe, ob der Container nicht in life_vehicles ist und gesperrt (locked) ist
        if (!(_x in life_vehicles) && {locked _x isEqualTo 2}) exitWith {
            hint localize "STR_MISC_VehInventory"; // Zeige eine Meldung an, dass es sich um das Fahrzeuginventar handelt
            true breakOut "main"; // Verlasse den "main"-Scope
        };
    };

    // Erlaube es, lebende Spieler, die bewusstlos sind, zu looten, aber nicht die toten
    if (_x isKindOf "CAManBase" && {!alive _x}) exitWith {
        hint localize "STR_NOTF_NoLootingPerson"; // Zeige eine Meldung an, dass tote Spieler nicht gelootet werden können
        true breakOut "main"; // Verlasse den "main"-Scope
    };
} count [_container, _secContainer]; // Iteriere über _container und _secContainer

// Starte einen neuen Spawn-Block
[] spawn {
    private _startTime = time; // Aktuelle Zeit speichern
    // Warte, bis ein Display (Dialog) mit der ID 49 gefunden wird oder die Zeit mehr als 2,5 Sekunden vergangen ist
    waitUntil {!(isNull (findDisplay 49)) || time > (_startTime + 2.5)};
    // Wenn ein Display (Dialog) mit der ID 49 nicht null ist, schließe es nach 2,5 Sekunden
    if !(isNull (findDisplay 49)) then {
        (findDisplay 49) closeDisplay 2; // Schließe das ESC-Dialog
    };
};
