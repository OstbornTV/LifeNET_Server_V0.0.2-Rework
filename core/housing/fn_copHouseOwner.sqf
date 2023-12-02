#include "..\..\script_macros.hpp"
/*
    File: fn_copHouseOwner.sqf
    Author: [Author Name]

    Description:
    Displays the house owner's information.

    Optimizations:
    - Removed unnecessary use of BIS_fnc_param and simplified parameter handling.
    - Improved code readability and added comments for better understanding.
*/

// Function parameters: _this (reserved for event handlers), _house (targeted house object)
private ["_house"];
_house = _this select 0;

// Check if the targeted object is a valid house
if (isNull _house || !(_house isKindOf "House_F")) exitWith {};

// Check if the house has an owner
if (isNil {(_house getVariable "house_owner")}) exitWith {hint localize "STR_House_Raid_NoOwner"};

// Display the house owner's information in a formatted hint
hint parseText format ["<t color='#FF0000'><t size='2'>" +(localize "STR_House_Raid_Owner")+ "</t></t><br/>%1",(_house getVariable "house_owner") select 1];
