/*
    File: fn_deathScreen.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Handles information displayed on the death screen while it is active.
*/

// Disable serialization for improved efficiency
disableSerialization;

// Get references to the medic-related controls on the death screen
private ["_medicsOnline","_medicsNear"];
_medicsOnline = ((findDisplay 7300) displayCtrl 7304);
_medicsNear = ((findDisplay 7300) displayCtrl 7305);

// Wait until the death screen is closed
waitUntil {
    // Check if there are independent (medic) units near the player
    _nearby = if (([independent,getPosATL player,120] call life_fnc_nearUnits)) then {"Yes"} else {"No"};

    // Update the text for the number of online medics
    _medicsOnline ctrlSetText format [localize "STR_Medic_Online",independent countSide playableUnits];

    // Update the text for the number of medics near the player
    _medicsNear ctrlSetText format [localize "STR_Medic_Near",_nearby];

    // Pause execution for 1 second before checking the condition again
    sleep 1;

    // Check if the death screen has been closed, and exit the loop if true
    (isNull (findDisplay 7300))
};
