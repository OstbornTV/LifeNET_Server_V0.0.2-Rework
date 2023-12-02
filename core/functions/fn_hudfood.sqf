#include "..\..\script_macros.hpp"

// fn_hudfood.sqf

// Festlegen des Wertes basierend auf dem Zustand des Spielers (bewusstlos oder nicht)
private _wert = if (player getVariable ["ACE_isUnconscious", false]) then {5} else {10};

// Überprüfen, ob der Hunger des Spielers unter 2 liegt
if (life_hunger < 2) then {
    player setDamage 1; // Spieler erleidet Schaden
    hint localize "STR_NOTF_EatMSG_Death"; // Meldung anzeigen: "Du bist vor Hunger gestorben."
} else {
    // Reduziere den Hunger des Spielers um den festgelegten Wert
    life_hunger = life_hunger - _wert;
    
    // Aktualisiere das HUD (Kopfzeile)
    [] spawn life_fnc_hudUpdate;

    // Erneut überprüfen, ob der Hunger des Spielers jetzt unter 2 liegt
    if (life_hunger < 2) then {
        player setDamage 1; // Spieler erleidet Schaden
        hint localize "STR_NOTF_EatMSG_Death"; // Meldung anzeigen: "Du bist vor Hunger gestorben."
    };

    // Überprüfe den aktuellen Hungerwert und zeige entsprechende Meldungen an
    switch (life_hunger) do {
        case 30: {hint localize "STR_NOTF_EatMSG_1";}; // Meldung anzeigen: "Du bist hungrig."
        case 20: {hint localize "STR_NOTF_EatMSG_2";}; // Meldung anzeigen: "Du bist sehr hungrig."
        case 10: {
            hint localize "STR_NOTF_EatMSG_3"; // Meldung anzeigen: "Du bist extrem hungrig."
            
            // Falls in den Spieleinstellungen die Ermüdung aktiviert ist, setze die Ermüdung des Spielers auf 1.
            if (LIFE_SETTINGS(getNumber, "enable_fatigue") isEqualTo 1) then {
                player setFatigue 1;
            };
        };
    };
};
