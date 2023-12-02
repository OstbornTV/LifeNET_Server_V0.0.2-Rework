#include "..\..\script_macros.hpp"
/*
    File: fn_freezePlayer.sqf
    Author: ColinM9991

    Description:
    Frieren Sie den ausgewählten Spieler ein oder tauen Sie ihn auf.
*/

params [
    ["_admin", objNull, [objNull]] // Parameter für den ausführenden Administrator
];

// Überprüft, ob der Spieler eingefroren ist
if (life_frozen) then {
    hint localize "STR_NOTF_Unfrozen"; // Anzeige einer Benachrichtigung, dass der Spieler aufgetaut wurde
    [1, format [localize "STR_ANOTF_Unfrozen", profileName]] remoteExecCall ["life_fnc_broadcast", _admin];
} else {
    hint localize "STR_NOTF_Frozen"; // Anzeige einer Benachrichtigung, dass der Spieler eingefroren wurde
    [1, format [localize "STR_ANOTF_Frozen", profileName]] remoteExecCall ["life_fnc_broadcast", _admin];
};

life_frozen = !life_frozen; // Umkehrung des Status "eingefroren"
disableUserInput life_frozen; // Deaktiviert die Benutzereingabe, wenn der Spieler eingefroren ist
