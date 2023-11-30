#include "..\..\script_macros.hpp"
/*
    File: fn_packupSpikes.sqf
    Author: Bryan "Tonic" Boardwine edit DomT602
    Description:
    Packs up a deployed spike strip.
*/

// Finde die nächsten Reifenstecher in der Nähe des Spielers
private _spikes = nearestObjects [player, ["Land_Razorwire_F"], 8] select 0;
if (isNull _spikes) exitWith {};

// Überprüfe, ob der Spieler das Einpacken des Reifenstechers schafft
if ([true, "spikeStrip", 1] call life_fnc_handleInv) then {
    // Finde den Index des Reifenstechers im life_spikesDeployed Array
    private _index = life_spikesDeployed findIf { _x isEqualTo _spikes };
    // Entferne den Reifenstecher aus dem Array
    life_spikesDeployed deleteAt _index;
    // Zeige eine Benachrichtigung an
    titleText [localize "STR_NOTF_SpikeStrip", "PLAIN"];
    // Lösche den Reifenstecher
    deleteVehicle _spikes;
};
