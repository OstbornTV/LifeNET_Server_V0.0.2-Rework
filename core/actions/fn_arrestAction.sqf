#include "..\..\script_macros.hpp"
// File: fn_arrestAction.sqf
// Author: Dein Name (ersetze dies mit deinem Namen)
// Description: Verhaftet die zielgerichtete Person.

params [
    ["_unit", objNull, [objNull]]
];

// Überprüfe, ob das Zielobjekt gültig ist und ein Spieler ist
if (isNull _unit || {!isPlayer _unit}) exitWith {};

// Überprüfe, ob das Zielobjekt eingeschränkt ist und die Fraktion zivil oder unabhängig ist
if (!(_unit getVariable "restrained") || !((side _unit) in [civilian, independent])) exitWith {};

// Wenn der Headless Client aktiv ist, rufe die entsprechende Funktion auf, sonst die lokale Funktion
if (life_HC_isActive) then {
    [getPlayerUID _unit, _unit, player, false] remoteExecCall ["HC_fnc_wantedBounty", HC_Life];
} else {
    [getPlayerUID _unit, _unit, player, false] remoteExecCall ["life_fnc_wantedBounty", RSERV];
};

// Trenne das Zielobjekt
detach _unit;

// Rufe die Funktion auf, um den Spieler ins Gefängnis zu schicken
[_unit, false] remoteExecCall ["life_fnc_jail", _unit];

// Sende eine Broadcast-Nachricht an alle Clients, um die Verhaftung zu verkünden
[0, "STR_NOTF_Arrested_1", true, [_unit getVariable ["realname", name _unit], profileName]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

// Wenn die erweiterte Protokollierung aktiviert ist, erstelle eine Meldung für das erweiterte Protokoll
if (LIFE_SETTINGS(getNumber, "player_advancedLog") isEqualTo 1) then {
    // Überprüfe die Einstellungen für freundliches Logging von BattlEye
    if (LIFE_SETTINGS(getNumber, "battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_Arrested_BEF", _unit getVariable ["realname", name _unit]];
    } else {
        advanced_log = format [localize "STR_DL_AL_Arrested", profileName, (getPlayerUID player), _unit getVariable ["realname", name _unit]];
    };
    // Sende die Meldung an den Server
    publicVariableServer "advanced_log";
};
