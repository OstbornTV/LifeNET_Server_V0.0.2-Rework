#include "..\..\script_macros.hpp"
/*
    File: fn_gangDisband.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Benachrichtigt den Benutzer über die Auflösung der Gang und wenn der Benutzer zustimmt, wird die Gang aufgelöst und aus der Datenbank entfernt.
*/
// Zeige eine Meldung an den Benutzer und fordere eine Aktion an
private _action = [
    localize "STR_GNOTF_DisbandWarn", // Nachricht über die Warnung
    localize "STR_Gang_Disband_Gang", // Meldungstext für Ja/Nein-Dialog
    localize "STR_Global_Yes", // Text für die "Ja"-Option
    localize "STR_Global_No" // Text für die "Nein"-Option
] call BIS_fnc_guiMessage;

// Überprüfe die Benutzeraktion
if (_action) then {
    // Zeige einen Hinweis an, dass die Gang aufgelöst wird
    hint localize "STR_GNOTF_DisbandGangPro";

    // Überprüfe, ob der Headless Client aktiv ist, und rufe die entsprechende Funktion auf
    if (life_HC_isActive) then {
        [group player] remoteExec ["HC_fnc_removeGang",HC_Life];
    } else {
        [group player] remoteExec ["TON_fnc_removeGang",RSERV];
    };
} else {
    // Zeige einen Hinweis an, dass die Auflösung der Gang abgebrochen wurde
    hint localize "STR_GNOTF_DisbandGangCanc";
};