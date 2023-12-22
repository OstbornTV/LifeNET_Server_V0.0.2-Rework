#include "..\..\script_macros.hpp"
/*
    File: fn_impoundMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Eigentlich kein Einlagerungsmenü, was für einige Verwirrung stiften kann, aber das ist beabsichtigt.
    Der Zweck dieses Menüs ist es, als 'Garage' bezeichnet zu werden, in der Fahrzeuge (persistente Fahrzeuge) gespeichert werden.
*/
// Lokale Variablen deklarieren
private ["_vehicles", "_control"];

// Serialisierung deaktivieren
disableSerialization;

// Parameter extrahieren
_vehicles = param [0, [], [[]]];

// GUI-Elemente ausblenden
ctrlShow [2803, false];
ctrlShow [2830, false];

// Warten, bis das Display 2800 erstellt wurde
waitUntil {!isNull (findDisplay 2800)};

// Wenn keine Fahrzeuge vorhanden sind, die Funktion verlassen
if (count _vehicles isEqualTo 0) exitWith {
    ctrlSetText [2811, localize "STR_Garage_NoVehicles"];
};

// Fahrzeugauswahlliste leeren
_control = CONTROL(2800, 2802);
lbClear _control;

// Fahrzeuge zur GUI hinzufügen
{
    // Fahrzeuginformationen abrufen
    _vehicleInfo = [(_x select 2)] call life_fnc_fetchVehInfo;

    // Fahrzeugname zur Liste hinzufügen
    _control lbAdd (_vehicleInfo select 3);

    // Fahrzeugdaten als Zeichenkette speichern und setzen
    _tmp = [(_x select 2), (_x select 8)];
    _tmp = str(_tmp);
    _control lbSetData [(lbSize _control) - 1, _tmp];

    // Fahrzeugbild und -wert setzen
    _control lbSetPicture [(lbSize _control) - 1, (_vehicleInfo select 2)];
    _control lbSetValue [(lbSize _control) - 1, (_x select 0)];
} forEach _vehicles;

// GUI-Elemente wieder einblenden
ctrlShow [2810, false];
ctrlShow [2811, false];
