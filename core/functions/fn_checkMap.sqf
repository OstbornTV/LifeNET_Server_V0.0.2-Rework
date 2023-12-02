#include "..\..\script_macros.hpp"
/*
    Datei: fn_checkMap.sqf
    Autor: domT602

    Beschreibung:
    Überprüft, ob die Karte geöffnet oder geschlossen wird, und platziert dann Marker entsprechend der Fraktion.
*/

params [
    ["_mapOpen", false, [false]]  // Parameter zum Überprüfen, ob die Karte geöffnet oder geschlossen ist
];

if (_mapOpen) then {
    switch playerside do {
        case west: {
            [] spawn life_fnc_copMarkers;  // Spawnt Polizei-Marker, wenn der Spieler auf der Westseite ist
        };
        case independent: {
            [] spawn life_fnc_medicMarkers;  // Spawnt Medic-Marker, wenn der Spieler unabhängig ist
        };
        case civilian: {
            [] spawn life_fnc_civMarkers;  // Spawnt Zivilisten-Marker, wenn der Spieler ein Zivilist ist
        };
    };

    if (life_markers && !life_markers_active) then {
        [true] spawn life_fnc_adminMarkers;  // Spawnt Admin-Marker, wenn life_markers aktiv ist und Marker nicht bereits aktiv sind
    };
} else {
    life_markers_active = false;  // Deaktiviert Marker, wenn die Karte geschlossen ist
};
