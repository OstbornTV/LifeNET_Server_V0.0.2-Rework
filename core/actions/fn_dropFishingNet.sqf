#include "..\..\script_macros.hpp"
/*
    File: fn_dropFishingNet.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Drops a virtual fishing net from the boat.
*/

// Überprüfe, ob das Fahrzeug ein Boot ist
private _vehicle = vehicle player;
if !(_vehicle isKindOf "Ship") exitWith {};

// Suche nach Fischen in der Nähe des Bootes
private _fish = nearestObjects[getPosASL _vehicle, ["Fish_Base_F"], 20];
life_net_dropped = true;

// Zeige eine Meldung über den Netzwurf an und warte 5 Sekunden
titleText[localize "STR_NOTF_NetDrop", "PLAIN"];
sleep 5;

// Überprüfe, ob Fische gefunden wurden
if (_fish isEqualTo []) exitWith {
    titleText[localize "STR_NOTF_NetDropFail", "PLAIN"];
    life_net_dropped = false;
};

// Iteriere durch gefundene Fische
{
    if (_x isKindOf "Fish_Base_F") then {
        // Bestimme die Informationen zum gefangenen Fisch
        private _fishInfo = switch (typeOf _x) do {
            case "Salema_F": {["STR_ANIM_Salema", "salema_raw"]};
            case "Ornate_random_F": {["STR_ANIM_Ornate", "ornate_raw"]};
            case "Mackerel_F": {["STR_ANIM_Mackerel", "mackerel_raw"]};
            case "Tuna_F": {["STR_ANIM_Tuna", "tuna_raw"]};
            case "Mullet_F": {["STR_ANIM_Mullet", "mullet_raw"]};
            case "CatShark_F": {["STR_ANIM_Catshark", "catshark_raw"]};
            default {["", ""]};
        };

        // Weitere Logik zum Fischfang
        _fishInfo params ["_fishName", "_fishType"];
        _fishName = localize _fishName;

        // Warte 3 Sekunden und füge den gefangenen Fisch dem Inventar hinzu
        sleep 3;
        if ([true, _fishType, 1] call life_fnc_handleInv) then {
            deleteVehicle _x;
            titleText[format [(localize "STR_NOTF_Fishing"), _fishName], "PLAIN"];
        };
    };
    true
} count _fish;

// Warte 1,5 Sekunden und zeige eine Meldung, dass das Netz wieder eingeholt wurde
sleep 1.5;
titleText[localize "STR_NOTF_NetUp", "PLAIN"];
life_net_dropped = false;
