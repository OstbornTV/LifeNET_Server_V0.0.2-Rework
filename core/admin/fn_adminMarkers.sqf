#include "..\..\script_macros.hpp"
/*
    File: fn_adminMarkers.sqf
    Author: Jason_000
    Description: Zeigt Marker für alle Spieler an
*/

// Parameterdefinition
params [
    ["_reOpen", false, [false]]
];

// Überprüft den Admin-Level
if (FETCH_CONST(life_adminlevel) < 4) exitWith {closeDialog 0; hint localize "STR_ANOTF_ErrorLevel";};

// Aktiviert die Marker-Anzeige
life_markers_active = true;

// Überprüft, ob die Funktion neu geöffnet werden soll
if !(_reOpen) then {
    life_markers = !life_markers;
    hint localize (["STR_ANOTF_MDisabled", "STR_ANOTF_MEnabled"] select life_markers);
};

// Hauptschleife für die Aktualisierung der Marker
for "_i" from 0 to 1 step 0 do {
    // Überprüft, ob die Marker deaktiviert oder nicht mehr aktiv sind
    if !(life_markers && {life_markers_active}) exitWith {};
    
    // Initialisiert leeres Array für Marker-Namen
    private _markers = [];

    // Erstellt Marker für alle Spieler
    {
        // Ermittelt die Seitenfarbe für den Marker
        private _colour = switch (side _x) do {
            case west: {"colorBLUFOR"};
            case independent: {"colorIndependent"};
            case east: {"colorOPFOR"};
            default {"colorCivilian"};
        };

        // Setzt den Marker für den Spieler
        private _name = name _x;
        createMarkerLocal[_name, position _x];
        _name setMarkerTypeLocal "mil_dot";
        _name setMarkerColorLocal _colour;
        _name setMarkerTextLocal _name;
        _markers pushBack _name;
        true

    } count (allPlayers - entities "HeadlessClient_F");

    // Wartet für eine kurze Zeit, bevor die Marker gelöscht werden
    sleep 0.5;
    
    // Löscht alle erstellten Marker
    {deleteMarkerLocal _x} count _markers;
};
