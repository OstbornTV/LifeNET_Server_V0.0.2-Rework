#include "..\..\script_macros.hpp"
/*
    Datei: fn_requestMedic.sqf
    Autor: Bryan "Tonic" Boardwine
    Edit: OsbornTV

    Beschreibung:
    Sendet eine Anfrage an Medics (Independent)
*/

// Überprüfe, ob Medics (Independent) im Raum sind.
private "_medicsOnline";
_medicsOnline = {!(_x isEqualTo player) && {side _x isEqualTo independent} && {alive _x}} count playableUnits > 0;

// Setze die Variable "Revive" für die Leiche auf false, um sie wiederbelebbar zu machen.
life_corpse setVariable ["Revive", false, true];

if (_medicsOnline) then {
    // Es gibt Medics, lassen Sie uns ihnen die Anfrage senden.
    [life_corpse, profileName] remoteExecCall ["life_fnc_medicRequest", independent];
}

// Erstelle einen Thread, um die vergangene Zeit seit der letzten Anfrage zu überwachen (um Spam zu verhindern).
[] spawn {
    ((findDisplay 7300) displayCtrl 7303) ctrlEnable false;
    sleep (2 * 60);
    ((findDisplay 7300) displayCtrl 7303) ctrlEnable true;
};
