#include "..\..\script_macros.hpp"
/*
    File: fn_soundDevice.sqf
    Author:

    Description:
    Plays a device sound for mining (Mainly Tempest device).
*/
params [
    ["_vehicle", objNull, [objNull]] // Das Fahrzeugobjekt, für das der Sound abgespielt wird
];

// Exit, wenn das Fahrzeugobjekt nicht vorhanden ist oder der Spieler mehr als 2500 Einheiten entfernt ist
if (isNull _vehicle || player distance _vehicle > 2500) exitWith {};

// Schleife für die Geräuschwiedergabe
for "_i" from 0 to 1 step 0 do {
    // Exit, wenn das Fahrzeug nicht mehr lebendig ist oder die "mining"-Variable nicht vorhanden ist
    if !(alive _vehicle) exitWith {};
    if (isNil {_vehicle getVariable "mining"}) exitWith {};

    // Spiele den Geräuschschleifen-Sound ab
    _vehicle say3D ["Device_disassembled_loop", 150, 1];

    // Wartezeit vor der erneuten Ausführung der Schleife
    sleep 28.6;
};
