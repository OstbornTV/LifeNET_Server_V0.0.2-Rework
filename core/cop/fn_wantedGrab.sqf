#include "..\..\script_macros.hpp"
/*
    File: fn_wantedGrab.sqf
    Author: ColinM

    Description:
    Prepare the array to query the crimes.
*/

// Deaktiviere die Serialisierung
disableSerialization;

// Holen Sie sich das Display-Objekt und die Steuerelemente
private _display = findDisplay 2400;
private _tab = _display displayCtrl 2402;

// Holen Sie sich den ausgewählten Kriminellen aus der ListBox
private _criminal = lbData[2401, (lbCurSel 2401)];
_criminal = call compile format ["%1", _criminal];

// Überprüfen Sie, ob der Kriminelle gültig ist, andernfalls beenden Sie das Skript
if (isNil "_criminal") exitWith {};

// Führen Sie die Abfrage der Verbrechen basierend auf dem Spielmodus durch (Headless Client oder Server)
if (life_HC_isActive) then {
    [player, _criminal] remoteExec ["HC_fnc_wantedCrimes", HC_Life];
} else {
    [player, _criminal] remoteExec ["life_fnc_wantedCrimes", RSERV];
};