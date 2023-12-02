#include "..\..\script_macros.hpp"
/*
    File: fn_ticketPaid.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Verifies that the ticket was paid.
*/

// Parameter:
// _value: Der Standardwert ist 5, falls kein Wert übergeben wird.
// _unit: Der Standardwert ist objNull, falls kein Wert übergeben wird.
params [
    ["_value", 5, [0]],
    ["_unit", objNull, [objNull]]
];

// Überprüfe, ob der übergebene "_unit" gültig ist und mit "life_ticket_unit" übereinstimmt
if (isNull _unit || !(_unit isEqualTo life_ticket_unit)) then {
    hint localize "STR_Cop_TicketPaidError";
    exitWith {};
};

// Extrahiere den echten Namen des Spielers
private _name = _unit getVariable ["realname", name _unit];

// Zeige eine Benachrichtigung an, dass das Ticket bezahlt wurde
hint format [localize "STR_Cop_Ticket_PaidNOTF_2", _name];

// Aktualisiere das Bankguthaben um den Wert des bezahlten Tickets
BANK = BANK + _value;

// Führe eine teilweise Aktualisierung des Inventars durch
[1] call SOCK_fnc_updatePartial;