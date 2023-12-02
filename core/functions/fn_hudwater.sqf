#include "..\..\script_macros.hpp"

/*
    File: fn_hudwater.sqf
    Author: Unbekannt

    Description:
    Verwaltet den Durst des Spielers und aktualisiert das HUD.
*/
private _wert = if(player getVariable ["ACE_isUnconscious",false]) then {5} else {10};

// Überprüfe, ob der Durst des Spielers unter 2 liegt
if (life_thirst < 2) then 
{
    // Setze den Spieler auf 1 Schadenspunkt und zeige eine Meldung an
    player setDamage 1; 
    hint localize "STR_NOTF_DrinkMSG_Death";
} 
else 
{
    // Verringere den Durst des Spielers um den festgelegten Wert
    life_thirst = life_thirst - _wert;
    
    // Rufe die Funktion zur Aktualisierung des HUD auf
    [] spawn life_fnc_hudUpdate;

    // Überprüfe erneut, ob der Durst des Spielers unter 2 liegt
    if (life_thirst < 2) then 
    {
        // Setze den Spieler auf 1 Schadenspunkt und zeige eine Meldung an
        player setDamage 1; 
        hint localize "STR_NOTF_DrinkMSG_Death";
    };

    // Verwende eine switch-Anweisung basierend auf dem Durstwert
    switch (life_thirst) do 
    {
        case 30: {hint localize "STR_NOTF_DrinkMSG_1";}; // Zeige eine Meldung bei Durst 30
        case 20: {
            hint localize "STR_NOTF_DrinkMSG_2"; // Zeige eine Meldung bei Durst 20
            // Überprüfe, ob Ermüdung aktiviert ist, und setze die Ermüdung des Spielers auf 1
            if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        };
        case 10: {
            hint localize "STR_NOTF_DrinkMSG_3"; // Zeige eine Meldung bei Durst 10
            // Überprüfe, ob Ermüdung aktiviert ist, und setze die Ermüdung des Spielers auf 1
            if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 1) then {player setFatigue 1;};
        };
    };
};
