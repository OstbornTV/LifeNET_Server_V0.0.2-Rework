#include "\life_server\script_macros.hpp"
/*
    File: fn_spikeStrip.sqf
    Author: DomT602
    Description:
    Adds spikestrip to server-side array and if required - starts the monitoring of spikestrips.
*/
params [
    ["_spikeStrip", objNull, [objNull]]
];

if (isNull _spikeStrip) exitWith {};

// Füge den Nagelstreifen zum serverseitigen Array hinzu
server_spikes pushBack _spikeStrip;

// Wenn die Anzahl der Nagelstreifen gleich 1 ist, starte das Überwachen der Nagelstreifen
if (count server_spikes isEqualTo 1) then {
    private _minSpikeSpeed = LIFE_SETTINGS(getNumber, "minimumSpikeSpeed");

    for "_i" from 0 to 1 step 0 do {
        // Beende die Schleife, wenn das serverseitige Array leer ist
        if (server_spikes isEqualTo []) exitWith {};

        {
            // Überprüfe jedes Fahrzeug in der Nähe der Nagelstreifen
            (nearestObjects [_x, ["Car"], 5]) params [["_nearVeh", objNull]];

            // Wenn das Fahrzeug lebendig ist und die Geschwindigkeit über dem Mindestwert liegt
            if (alive _nearVeh && {abs (speed _nearVeh) > _minSpikeSpeed}) then {
                // Führe die Funktion "life_fnc_spikeStripEffect" auf dem Fahrzeug aus
                [_nearVeh] remoteExecCall ["life_fnc_spikeStripEffect", _nearVeh];

                // Lösche den Nagelstreifen
                deleteVehicle _x;
            };
        } forEach server_spikes;

        // Entferne Null-Objekte aus dem serverseitigen Array
        server_spikes = server_spikes - [objNull];

        // Kurze Pause
        uiSleep 1e-6;
    };
};
