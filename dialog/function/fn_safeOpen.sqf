#include "..\..\script_macros.hpp"
/*
    File: fn_safeOpen.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Öffnet das Inventarmenü des Safes.
*/

// Überprüfen, ob bereits ein Dialog geöffnet ist
if (dialog) exitWith {};

// Das sichere Objekt als Parameter abrufen
life_safeObj = param [0, objNull, [objNull]];

// Bei ungültigem safeObj oder falls kein Zivilist, die Funktion verlassen
if (isNull life_safeObj) exitWith {};
if !(playerSide isEqualTo civilian) exitWith {};

// Wenn der Safe leer ist, eine Meldung anzeigen und die Funktion beenden
if ((life_safeObj getVariable ["safe", -1]) < 1) exitWith { hint localize "STR_Civ_VaultEmpty"; };

// Überprüfen, ob der Safe bereits in Benutzung ist
if (life_safeObj getVariable ["inUse", false]) exitWith { hint localize "STR_Civ_VaultInUse"; };

// Überprüfen, ob genügend Polizisten online sind
if (west countSide playableUnits < (LIFE_SETTINGS(getNumber, "minimum_cops"))) exitWith {
    hint format [localize "STR_Civ_NotEnoughCops", (LIFE_SETTINGS(getNumber, "minimum_cops"))];
};

// Dialog erstellen und bei Fehlern die Funktion beenden
if (!createDialog "Federal_Safe") exitWith { localize "STR_MISC_DialogError" };

// Serialisierung deaktivieren
disableSerialization;

// Text im Dialog setzen
ctrlSetText [3501, (localize "STR_Civ_SafeInv")];

// Funktion für das Safe-Inventory aufrufen
[life_safeObj] call life_fnc_safeInventory;

// Variable "inUse" für den Safe auf true setzen
life_safeObj setVariable ["inUse", true, true];

// Sicherstellen, dass die "inUse"-Variable wieder auf false gesetzt wird, nachdem der Dialog geschlossen wurde
[life_safeObj] spawn {
    waitUntil { isNull (findDisplay 3500) };
    (_this select 0) setVariable ["inUse", false, true];
};
