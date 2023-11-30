#include "..\..\script_macros.hpp"
/*
    File: fn_healHospital.sqf
    Author: Bryan "Tonic" Boardwine
    Reworked: Jesse "TKCJesse" Schultz
    Description:
    Prompts user with a confirmation dialog to heal themselves.
    Used at the hospitals to restore health to full.
    Note: Dialog helps stop a few issues regarding money loss.
*/
params [
    ["_target", objNull, [objNull]]
];

// Beende, wenn eine Aktion bereits in Benutzung ist
if (life_action_inUse) exitWith {};

// Beende, wenn die Gesundheit des Spielers bereits nahezu voll ist
if ((damage player) < 0.01) exitWith { hint localize "STR_NOTF_HS_FullHealth" };

// Erhalte die Heilkosten aus den Einstellungen
private _healCost = LIFE_SETTINGS(getNumber, "hospital_heal_fee");

// Beende, wenn der Spieler nicht genügend Geld hat
if (CASH < _healCost) exitWith { hint format [localize "STR_NOTF_HS_NoCash", [_healCost] call life_fnc_numberText] };

// Setze die Aktion als in Benutzung
life_action_inUse = true;

// Zeige eine Bestätigungsnachricht
private _action = [
    format [localize "STR_NOTF_HS_PopUp", [_healCost] call life_fnc_numberText],
    localize "STR_NOTF_HS_TITLE",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Schließe das Dialogfenster
closeDialog 0;

// Überprüfe die Benutzeraktion
if (_action) then {
    // Zeige eine Meldung, dass der Spieler geheilt wird
    titleText [localize "STR_NOTF_HS_Healing", "PLAIN"];

    // Warte für 8 Sekunden (kann angepasst werden)
    uiSleep 8;

    // Beende, wenn der Spieler zu weit entfernt ist
    if (player distance _target > 5) exitWith { life_action_inUse = false; titleText [localize "STR_NOTF_HS_ToFar", "PLAIN"] };

    // Zeige eine Meldung, dass der Spieler geheilt wurde
    titleText [localize "STR_NOTF_HS_Healed", "PLAIN"];

    // Setze die Gesundheit des Spielers auf 0
    player setDamage 0;

    // Ziehe die Heilkosten vom Geld des Spielers ab
    CASH = CASH - _healCost;

    // Aktualisiere das HUD
    [] call life_fnc_hudUpdate;
} else {
    // Zeige eine Meldung, dass die Aktion abgebrochen wurde
    hint localize "STR_NOTF_ActionCancel";
};

// Setze die Aktion als nicht in Benutzung
life_action_inUse = false;
