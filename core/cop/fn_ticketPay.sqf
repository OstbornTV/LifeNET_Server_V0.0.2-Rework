#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPay.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Pays the ticket.
*/

// Überprüfe, ob die benötigten Variablen existieren
if (isNil "life_ticket_val" || {isNil "life_ticket_cop"}) exitWith {};

// Überprüfe, ob der Spieler genug Bargeld hat, um das Ticket zu bezahlen
if (CASH < life_ticket_val) then {
    // Überprüfe, ob genug Geld auf der Bank ist
    if (BANK < life_ticket_val) then {
        hint localize "STR_Cop_Ticket_NotEnough";
        [1, "STR_Cop_Ticket_NotEnoughNOTF", true, [profileName]] remoteExecCall ["life_fnc_broadcast", life_ticket_cop];
        closeDialog 0;
    };

    // Bezahle das Ticket von der Bank
    hint format [localize "STR_Cop_Ticket_Paid", [life_ticket_val] call life_fnc_numberText];
    BANK = BANK - life_ticket_val;
    [1] call SOCK_fnc_updatePartial;
    life_ticket_paid = true;

    // Sende Rundfunknachrichten über die Bezahlung des Tickets
    [0, "STR_Cop_Ticket_PaidNOTF", true, [profileName, [life_ticket_val] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", west];
    [1, "STR_Cop_Ticket_PaidNOTF_2", true, [profileName]] remoteExecCall ["life_fnc_broadcast", life_ticket_cop];
    [life_ticket_val, player, life_ticket_cop] remoteExecCall ["life_fnc_ticketPaid", life_ticket_cop];

    // Entferne den Spieler von der Wanted-Liste
    if (life_HC_isActive) then {
        [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", HC_Life];
    } else {
        [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove", RSERV];
    };
    closeDialog 0;
};

// Bezahle das Ticket von Bargeld
CASH = CASH - life_ticket_val;
[0] call SOCK_fnc_updatePartial;
life_ticket_paid = true;

// Entferne den Spieler von der Wanted-Liste
if (life_HC_isActive) then {
    [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", HC_Life];
} else {
    [getPlayerUID player] remoteExecCall ["life_fnc_wantedRemove", RSERV];
};

// Sende Rundfunknachrichten über die Bezahlung des Tickets
[0, "STR_Cop_Ticket_PaidNOTF", true, [profileName, [life_ticket_val] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", west];
closeDialog 0;
[life_ticket_val, player] remoteExecCall ["life_fnc_ticketPaid", life_ticket_cop];