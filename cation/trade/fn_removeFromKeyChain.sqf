/*
    File: fn_removeFromKeyChain.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Removes vehicle/house from key chain
*/
params[["_item",objNull,[objNull]]];

if (isServer) exitWith {};

private _index = life_vehicles find _item;
if !(_index isEqualTo -1) then {
    life_vehicles deleteAt _index;
};