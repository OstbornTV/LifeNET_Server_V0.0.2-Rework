#include "..\..\script_macros.hpp"
/*
    File: fn_knockoutAction.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Setzt das Ziel außer Gefecht.
*/

params [
    ["_target", objNull, [objNull]]
];

// Fehlerüberprüfung
if (isNull _target || {player distance _target > 4}) exitWith {};

// Setzt den Zustand "außer Gefecht" auf true
life_knockout = true;

// Synchronisiert die "AwopPercMstpSgthWrflDnon_End2"-Animation mit dem Spieler
[player, "AwopPercMstpSgthWrflDnon_End2"] remoteExecCall ["life_fnc_animSync", RCLIENT];

// Kurze Verzögerung
sleep 0.08;

// Ruft das Skript zum Außer-Gefecht-Setzen auf dem Zielobjekt auf
[_target, profileName] remoteExec ["life_fnc_knockedOut", _target];

// Warte 3 Sekunden
sleep 3;

// Setzt den Zustand "außer Gefecht" auf false
life_knockout = false;
