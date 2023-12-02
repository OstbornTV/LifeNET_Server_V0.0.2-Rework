#include "..\..\script_macros.hpp"

/*
    File: fn_spikeStrip.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Creates a spike strip and preps it.
*/

// Maximale Anzahl von Spike Strips aus den Einstellungen abrufen
private _maxSpikeCount = LIFE_SETTINGS(getNumber, "maximumSpikestrips");

// Überprüfen, ob die maximale Anzahl an Spike Strips erreicht wurde
life_spikesDeployed = life_spikesDeployed - [objNull];

if (_maxSpikeCount != -1 && {(count life_spikesDeployed) isEqualTo _maxSpikeCount}) then {
    hint format [localize "STR_ISTR_MaxSpikesDeployed", _maxSpikeCount];
    exitWith {};
};

// Spike Strip erstellen und vorbereiten
private _spikeStrip = "Land_Razorwire_F" createVehicle [0, 0, 0];
_spikeStrip attachTo [player, [0, 5.5, 0]];
_spikeStrip setDir 90;

// Spike Strip zur Liste der deployten Strips hinzufügen
life_spikeStrip = _spikeStrip;
life_spikesDeployed pushBack _spikeStrip;

// Action zum Platzieren des Spike Strips hinzufügen
life_action_spikeStripDeploy = player addAction [
    localize "STR_ISTR_Spike_Place",
    life_fnc_deploySpikes,
    "", // Kein spezielles Aktionstextformat
    0, // Priorität
    false, // Wiederholbar
    false, // Abbrechbar
    "", // Skript-Parameter
    '!isNull life_spikestrip' // Bedingung für das Ausführen der Aktion
];
