#include "\life_hc\hc_macros.hpp"
/*
    File: fn_receiveKeyOfServer.sqf
    Author: NiiRoZz

    This file is for Nanou's HeadlessClient.

    Description:
    Recovers the key of a player when reconnecting.
*/
private ["_keyArr", "_uid", "_side"];

// Extract the key array from the input parameter
_keyArr = _this select 0;

// Set the global variable with the key array
life_keyreceivedvar = _keyArr;

// Signal that the key has been received
life_keyreceived = true;
