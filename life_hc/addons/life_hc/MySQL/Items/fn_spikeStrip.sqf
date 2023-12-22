#include "\life_hc\hc_macros.hpp"

/*
    File: fn_spikeStrip.sqf
    Author: DomT602
    This file is for Nanou's HeadlessClient.
    Description:
    Adds spikestrip to hc-side array and if required - starts the monitoring of spikestrips.
*/

params [
    ["_spikeStrip", objNull, [objNull]]
];

// Exit if the spike strip is null
if (isNull _spikeStrip) exitWith {};

// Add the spike strip to the hc-side array
hc_spikes pushBack _spikeStrip;

// Check if this is the first spike strip, if so, start monitoring
if (count hc_spikes isEqualTo 1) then {
    // Define the minimum spike speed
    private _minSpikeSpeed = LIFE_SETTINGS(getNumber, "minimumSpikeSpeed");

    for "_i" from 0 to 1 step 0 do {
        // Exit if no spike strips are present
        if (hc_spikes isEqualTo []) exitWith {};

        {
            // Find vehicles near the spike strip within a 5-meter radius
            (nearestObjects [_x, ["Car"], 5]) params [["_nearVeh", objNull]];

            // Check if the nearby vehicle is alive and exceeds the minimum spike speed
            if (alive _nearVeh && {abs (speed _nearVeh) > _minSpikeSpeed}) then {
                // Trigger the spike strip effect on the nearby vehicle
                [_nearVeh] remoteExecCall ["life_fnc_spikeStripEffect", _nearVeh];

                // Delete the spike strip
                deleteVehicle _x;
            };
        } forEach hc_spikes;

        // Remove null elements from the hc_spikes array
        hc_spikes = hc_spikes - [objNull];

        // Sleep for a very short time to avoid excessive resource usage
        uiSleep 1e-6;
    };
};
