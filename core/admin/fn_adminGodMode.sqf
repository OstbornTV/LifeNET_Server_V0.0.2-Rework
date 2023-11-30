#include "..\..\script_macros.hpp"
/*
    File: fn_adminGodMode.sqf
    Author: Tobias 'Xetoxyc' Sittenauer
    
    Description: Aktiviert den God-Modus für Admins
*/

// Überprüfen Sie das Admin-Level
if (FETCH_CONST(life_adminlevel) < 4) exitWith {
    closeDialog 0;
    hint localize "STR_ANOTF_ErrorLevel";
};

// Schließen Sie das Dialogfeld
closeDialog 0;

// Toggle God-Modus
if (life_god) then {
    titleText [localize "STR_ANOTF_godModeOff","PLAIN"];
} else {
    titleText [localize "STR_ANOTF_godModeOn","PLAIN"];
};
titleFadeOut 2;

// Aktivieren/Deaktivieren Sie den Schaden für den Spieler
player allowDamage life_god;
life_god = !life_god;
