#include "..\script_macros.hpp"

/*
    File: fn_teargas.sqf
    Author: Blackd0g, Updated by Jokahghost
    Description: 
    Simulates the effects of tear gas on the player
*/

playerNearGas = false;

[] spawn {
    while {true} do {
        // Check if player is near a gas grenade
        if ((nearestObject [getPos player, "SmokeShellYellow"] distance player < 20) or
            (nearestObject [getPos player, "G_40mm_SmokeYellow"] distance player < 15)) then {
            playerNearGas = true;
        } else {
            playerNearGas = false;
        };

        uiSleep 3;
    };
};

[] spawn {
    while {true} do {
        // Reset visual effects when not near gas
        if (!playerNearGas) then {
            "dynamicBlur" ppEffectEnable true;
            "dynamicBlur" ppEffectAdjust [0];
            "dynamicBlur" ppEffectCommit 15;
            resetCamShake;
            20 fadeSound 1;
        }

        // Wait until a Gas Grenade is near the player
        waitUntil {playerNearGas};

        // Check if player has a gas mask
        gasMaskItem = (headgear player == "H_CrewHelmetHeli_B") ? 2581 : 2583;

        if (gasMaskItem == 2583) then {
            // Apply effects when not wearing a gas mask
            "dynamicBlur" ppEffectEnable true;
            "dynamicBlur" ppEffectAdjust [20];
            "dynamicBlur" ppEffectCommit 3;
            enableCamShake false;
            addCamShake [10, 45, 10];
            player setFatigue 1;
            5 fadeSound 0.1;
        };

        uiSleep 1;
    };
};