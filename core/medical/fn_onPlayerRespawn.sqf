#include "..\..\script_macros.hpp"
/*
    Datei: fn_onPlayerRespawn.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Tut etwas, aber ich werde es nicht wissen, bis ich es schreibe...
*/
private ["_unit","_corpse","_containers"];
_unit = _this select 0;
_corpse = _this select 1;
life_corpse = _corpse;

// Setze einige Variablen auf unserem neuen Körper.
_unit setVariable ["restrained", false, true];
_unit setVariable ["Escorting", false, true];
_unit setVariable ["transporting", false, true];
_unit setVariable ["playerSurrender", false, true];
_unit setVariable ["steam64id", getPlayerUID player, true]; // Setze die UID zurück.
_unit setVariable ["realname", profileName, true]; // Setze den Namen des Spielers zurück.

// Spiele eine bestimmte Bewegung (Animation) für den Spieler ab
player playMoveNow "AmovPpneMstpSrasWrflDnon";

// Setze die Aktionen für den Spieler neu auf
[] call life_fnc_setupActions;

// Verwalte den Seitensprechkanal für den Spieler
[_unit, life_settings_enableSidechannel, playerSide] remoteExecCall ["TON_fnc_manageSC", RSERV];

// Deaktiviere Ermüdung, wenn die Option aktiviert ist
if (LIFE_SETTINGS(getNumber, "enable_fatigue") isEqualTo 0) then {
    player enableFatigue false;
};
