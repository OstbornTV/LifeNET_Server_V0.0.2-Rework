#include "\life_server\script_macros.hpp"
/*
    Author: GetSomePanda / Panda
    SteamID: 76561198145366418
    File Name: fn_handleBlastingCharge.sqf
    Information: Handles the fed explosion over the server so if the client who places the charge logs out it still blows up.
*/

// Warte bis die Zeit für die Explosion erreicht ist oder bis die Sprengladung platziert wurde
private _time = time + LIFE_SETTINGS(getNumber, "fed_chargeTime") * 60;
waitUntil { round(_time - time) < 1 || !(fed_bank getVariable ["chargeplaced", false]) };

// Wenn keine Sprengladung platziert wurde, beende den Code
if !(fed_bank getVariable ["chargeplaced", false]) exitWith {};

// Hole die Position der Federal Reserve und füge einen Offset hinzu
private _pos = getPosATL fed_bank;
_pos vectorAdd [0, 0, 0.5];

// Erstelle ein Sprengladungsfahrzeug an der berechneten Position
private _bomb = "Bo_GBU12_LGB_MI10" createVehicle _pos;

// Setze die Variable "chargeplaced" zurück und öffne den Safe
fed_bank setVariable ["chargeplaced", false, true];
fed_bank setVariable ["safe_open", true, true];
