#include "..\..\script_macros.hpp"
/*

    File: fn_transferOwnership.sqf
    Author: BoGuu

    Description:
    Transfer agent ownership to HC upon its connection

*/

_which = param [0, false, [false]];

// Übertrage den Besitz der Einheiten an den Headless Client (HC)
if (_which) then {
    // Beende die Funktion, wenn der Headless Client (HC) nicht aktiv ist
    if (!life_HC_isActive) exitWith { diag_log "ERROR: Server is trying to give AI ownership to HC when life_HC_isActive is false"; };
    {
        // Übertrage den Besitz nur, wenn es sich nicht um einen Spieler handelt
        if (!(isPlayer _x)) then {
            _x setOwner HC_Life;  // Übertrage den Besitz an den HC
        };
    } forEach animals;

} else {
    // Beende die Funktion, wenn der Headless Client (HC) aktiv ist
    if (life_HC_isActive) exitWith { diag_log "ERROR: Server is trying to give AI ownership back to itself when life_HC_isActive is true"; };
    {
        // Übertrage den Besitz nur, wenn es sich nicht um einen Spieler handelt
        if (!(isPlayer _x)) then {
            _x setOwner RSERV;  // Übertrage den Besitz an den Server zurück
        };
    } forEach animals;
};
