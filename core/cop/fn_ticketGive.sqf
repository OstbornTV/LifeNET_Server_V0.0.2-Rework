#include "..\..\script_macros.hpp"
/*
    File: fn_ticketGive.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Gives a ticket to the targeted player.
*/

// Überprüfe, ob die Variable "life_ticket_unit" definiert ist
if (isNil "life_ticket_unit" || isNull life_ticket_unit) then {
    hint localize "STR_Cop_TicketError";
    exitWith {};
};

// Überprüfe, ob der Spieler bereits ein Ticket hat
if (life_ticket_unit getVariable ["hasTicket", false]) then {
    hint localize "STR_Cop_TicketExist";
    exitWith {};
};

// Hole den eingegebenen Geldbetrag aus dem Dialogfeld
private _val = ctrlText 2652;
private _parsedVal = parseNumber _val;

// Überprüfe, ob die Eingabe eine Zahl ist
if !([_val] call life_util_fnc_isNumber) then {
    hint localize "STR_Cop_TicketNum";
    exitWith {};
};

// Überprüfe, ob der Geldbetrag über 200000 liegt
if (_parsedVal > 200000) then {
    hint localize "STR_Cop_TicketOver100";
    exitWith {};
};

// Sende eine Rundfunknachricht über das erteilte Ticket
[0, "STR_Cop_TicketGive", true, [profileName, [_parsedVal] call life_fnc_numberText, life_ticket_unit getVariable ["realname", name life_ticket_unit]]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

// Führe die Funktion zur Anzeige des Ticket-Prompts aus
[player, _parsedVal] remoteExecCall ["life_fnc_ticketPrompt", life_ticket_unit];

// Markiere den Spieler als "hat ein Ticket"
life_ticket_unit setVariable ["hasTicket", true, true];

// Schließe das Dialogfeld
closeDialog 0;