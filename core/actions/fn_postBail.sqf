#include "..\..\script_macros.hpp"
/*
    File: fn_postBail.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Called when the player attempts to post bail.
                 Needs to be revised.
*/

params [
    "", // Platzhalter für unnötige Parameter entfernt
    ["_unit", objNull, [objNull]]
];

// Überprüfe, ob die Kaution bereits bezahlt wurde
if (life_bail_paid) exitWith {};

// Initialisiere die Kautionssumme, falls sie nicht vorhanden ist
if (isNil "life_bail_amount") then { life_bail_amount = 3500; };

// Überprüfe, ob der Spieler die Kaution bezahlen kann
if (!life_canpay_bail) exitWith { hint localize "STR_NOTF_Bail_Post"; };

// Überprüfe, ob der Spieler genügend Geld auf der Bank hat
if (BANK < life_bail_amount) exitWith { hint format [localize "STR_NOTF_Bail_NotEnough", life_bail_amount]; };

// Ziehe die Kaution vom Bankkonto ab
BANK = BANK - life_bail_amount;

// Markiere, dass die Kaution bezahlt wurde
life_bail_paid = true;

// Sende eine Aktualisierung an den Server und sende eine Rundfunknachricht aus
[1] call SOCK_fnc_updatePartial;
[0, "STR_NOTF_Bail_Bailed", true, [profileName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
