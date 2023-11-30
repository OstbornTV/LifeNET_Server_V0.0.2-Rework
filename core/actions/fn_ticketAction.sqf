#include "..\..\script_macros.hpp"
/*
    File: fn_ticketAction.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Starts the ticketing process.
*/
params [
    ["_unit", objNull, [objNull]]
];

// Überprüfen, ob das Dialogfeld erstellt werden kann
if !(createDialog "life_ticket_give") exitWith {
    hint localize "STR_Cop_TicketFail";
};

// Überprüfen, ob das Zielobjekt vorhanden und ein Spieler ist
if (isNull _unit || {!isPlayer _unit}) exitWith {};

// Text im Dialogfeld setzen
ctrlSetText [2651, format [localize "STR_Cop_Ticket", _unit getVariable ["realname", name _unit]]];

// Das Zielobjekt für das Ticketing speichern
life_ticket_unit = _unit;
