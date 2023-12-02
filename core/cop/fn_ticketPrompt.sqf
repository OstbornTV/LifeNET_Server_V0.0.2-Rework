#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPrompt
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Prompts the player that he is being ticketed.
*/

// Überprüfe, ob das Dialogfeld bereits geöffnet ist
if (!isNull (findDisplay 2600)) exitWith {};

// Parameter definieren
params [
    ["_cop", objNull, [objNull]],
    ["_val", -1, [0]]
];

// Überprüfe, ob gültige Parameter übergeben wurden
if (isNull _cop || {_val isEqualTo -1}) exitWith {};

// Erstelle das Dialogfeld "life_ticket_pay"
createDialog "life_ticket_pay";

// Setze die Ticket-bezogenen Variablen
life_ticket_paid = false;
life_ticket_val = _val;
life_ticket_cop = _cop;

// Aktualisiere den Text im Dialogfeld
CONTROL(2600, 2601) ctrlSetStructuredText parseText format ["<t align='center'><t size='.8px'>" + (localize "STR_Cop_Ticket_GUI_Given"), _cop getVariable ["realname", name _cop], _val];

// Warte darauf, dass das Ticket bezahlt wird oder das Dialogfeld geschlossen wird
[] spawn {
    waitUntil {life_ticket_paid || {isNull (findDisplay 2600)}};
    // Überprüfe, ob das Dialogfeld geschlossen wurde und das Ticket nicht bezahlt wurde
    if (isNull (findDisplay 2600) && {!life_ticket_paid}) then {
        // Sende Rundfunknachrichten über die Ablehnung des Tickets
        [0, "STR_Cop_Ticket_Refuse", true, [profileName]] remoteExecCall ["life_fnc_broadcast", west];
        [1, "STR_Cop_Ticket_Refuse", true, [profileName]] remoteExecCall ["life_fnc_broadcast", life_ticket_cop];
    };
};