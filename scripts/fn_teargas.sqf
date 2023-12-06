#include "..\script_macros.hpp"
/*
    File: fn_teargas.sqf
    Author: Blackd0g, Updated by Jokahghost
    Description: 
    Simuliert die Auswirkungen von Tränengas auf den Spieler
*/

// Variable zur Verfolgung der Nähe des Spielers zu Tränengas
playerNearGas = false;

// Thread, um ständig zu überprüfen, ob der Spieler in der Nähe von Tränengas ist
[] spawn {
    while {true} do {
        // Überprüfen, ob der Spieler in der Nähe einer Rauchgranate ist
        if ((nearestObject [getPos player, "SmokeShellYellow"] distance player < 20) or
            (nearestObject [getPos player, "G_40mm_SmokeYellow"] distance player < 15)) then {
            playerNearGas = true;
        } else {
            playerNearGas = false;
        };

        // Kurze Pause, bevor die Überprüfung erneut durchgeführt wird
        uiSleep 3;
    };
};

// Thread für die visuellen Effekte und Auswirkungen von Tränengas
[] spawn {
    while {true} do {
        // Visuelle Effekte zurücksetzen, wenn der Spieler nicht in der Nähe von Tränengas ist
        if (!playerNearGas) then {
            "dynamicBlur" ppEffectEnable true;
            "dynamicBlur" ppEffectAdjust [0];
            "dynamicBlur" ppEffectCommit 15;
            resetCamShake;
            20 fadeSound 1;
        }

        // Warten, bis eine Tränengasgranate in der Nähe des Spielers ist
        waitUntil {playerNearGas};

        // Überprüfen, ob der Spieler eine Gasmaske trägt
        gasMaskItem = (headgear player == "H_CrewHelmetHeli_B") ? 2581 : 2583;

        if (gasMaskItem == 2583) then {
            // Effekte anwenden, wenn keine Gasmaske getragen wird
            "dynamicBlur" ppEffectEnable true;
            "dynamicBlur" ppEffectAdjust [20];
            "dynamicBlur" ppEffectCommit 3;
            enableCamShake false;
            addCamShake [10, 45, 10];
            player setFatigue 1;
            5 fadeSound 0.1;
        };

        // Kurze Pause, bevor die Überprüfung erneut durchgeführt wird
        uiSleep 1;
    };
};
