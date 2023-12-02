#include "..\..\script_macros.hpp"
/*
    File: fn_jail.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Startet den initialen Prozess des Eingesperrtwerdens.
*/

params [
    ["_unit", objNull, [objNull]], // Der eingesperrte Spieler
    ["_bad", false, [false]] // Ein Flag, um zu kennzeichnen, ob der Spieler ein Krimineller ist
];

// Überprüft, ob der Spieler gültig ist
if (isNull _unit) exitWith {};
if !(_unit isEqualTo player) exitWith {};
if (life_is_arrested) exitWith {};

// Konfigurationseinstellungen für illegalen Besitz
private _illegalItems = LIFE_SETTINGS(getArray, "jail_seize_vItems");

// Setzt verschiedene Variable zurück und informiert den Spieler
player setVariable ["restrained", false, true];
player setVariable ["Escorting", false, true];
player setVariable ["transporting", false, true];

titleText [localize "STR_Jail_Warn", "PLAIN"];
hint localize "STR_Jail_LicenseNOTF";
player setPos (getMarkerPos "jail_marker");

// Falls der Spieler als "kriminell" markiert ist
if (_bad) then {
    waitUntil {alive player};
    sleep 1;
};

// Überprüft, ob der Spieler in der Nähe des Markers ist, wenn nicht, setzt ihn dorthin
if (player distance (getMarkerPos "jail_marker") > 40) then {
    player setPos (getMarkerPos "jail_marker");
};

// Entfernt Lizenzen des Spielers
[1] call life_fnc_removeLicenses;

// Überprüft und entfernt illegale Gegenstände aus dem Inventar des Spielers
{
    _amount = ITEM_VALUE(_x);
    if (_amount > 0) then {
        [false, _x, _amount] call life_fnc_handleInv;
    };
    true
} count _illegalItems;

// Markiert den Spieler als eingesperrt
life_is_arrested = true;

// Entscheidet, ob das Inventar des Spielers konfisziert werden soll oder nicht
if (LIFE_SETTINGS(getNumber, "jail_seize_inventory") isEqualTo 1) then {
    [] call life_fnc_seizeClient;
} else {
    removeAllWeapons player; // Entfernt alle Waffen des Spielers
    {
        player removeMagazine _x; // Entfernt alle Magazine des Spielers
    } count (magazines player);
};

// Führt die Jailing-Funktion aus (serverseitig oder Headless Client)
if (life_HC_isActive) then {
    [player, _bad] remoteExecCall ["HC_fnc_jailSys", HC_Life];
} else {
    [player, _bad] remoteExecCall ["life_fnc_jailSys", RSERV];
};

// Aktualisiert die Datenbankinformationen des Spielers
[5] call SOCK_fnc_updatePartial;
