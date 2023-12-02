#include "..\..\script_macros.hpp"
/*
    File: fn_garageRefund.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Refunds the player for the garage fee. 
    This script adds the refunded amount to the player's bank balance.

    Parameters:
    - _this select 0: The price to be refunded.
    - _this select 1: The unit (player) receiving the refund.
*/
_price = _this select 0; // The price to be refunded
_unit = _this select 1; // The unit (player) receiving the refund

// Check if the unit receiving the refund is the player
if !(_unit isEqualTo player) exitWith {};

// Add the refunded amount to the player's bank balance
BANK = BANK + _price;

// Update the player's data on the server (partial update)
[1] call SOCK_fnc_updatePartial;
