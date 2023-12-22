#include "..\..\script_macros.hpp"
/*
    File: fn_progressBar.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Initialisiert den Fortschrittsbalken.
*/

// Serialisierung deaktivieren
disableSerialization;

// Deklariere lokale Variablen für UI und Fortschrittsbalken
private ["_ui", "_progress"];

// Fortschrittsbalken initialisieren und darstellen
"progressBar" cutRsc ["life_progress", "PLAIN"];

// UI-Element aus dem Namensraum abrufen
_ui = uiNameSpace getVariable "life_progress";

// Fortschrittsbalken-Steuerungselement abrufen
_progress = _ui displayCtrl 38201;

// Fortschrittsbalken auf die Mitte positionieren
_progress progressSetPosition 0.5;
