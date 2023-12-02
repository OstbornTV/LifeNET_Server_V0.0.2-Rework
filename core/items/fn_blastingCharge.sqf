#include "..\..\script_macros.hpp"
/*
    File: fn_blastingCharge.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Blasting charge is used for the federal reserve vault and nothing more.. Yet.
*/

// Parametrisiere den Tresor und den Handle
private ["_vault","_handle"];
_vault = param [0, ObjNull, [ObjNull]];

// Überprüfe, ob der Tresor existiert und die richtige Art von Objekt ist
if (isNull _vault) exitWith { hint localize "STR_ISTR_Blast_BadObject"; };
if (typeOf _vault != "Land_CargoBox_V1_F") exitWith { hint localize "STR_ISTR_Blast_VaultOnly"; };
if (_vault getVariable ["chargeplaced", false]) exitWith { hint localize "STR_ISTR_Blast_AlreadyPlaced"; };
if (_vault getVariable ["safe_open", false]) exitWith { hint localize "STR_ISTR_Blast_AlreadyOpen"; };

// Überprüfe, ob genügend Polizisten anwesend sind
if (west countSide playableUnits < (LIFE_SETTINGS(getNumber, "minimum_cops"))) exitWith {
    hint format [localize "STR_Civ_NotEnoughCops", (LIFE_SETTINGS(getNumber, "minimum_cops"))];
};

// Definiere die Position des Tresorraums und WL_Rosche
private _vaultHouse = [[["WL_Rosche", "Land_Research_house_V1_F"]]] call life_util_fnc_terrainSort;
private _wl_roscheArray = [16019.5, 16952.9, 0];
private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

// Überprüfe, ob der Tresorraum gesperrt ist, bevor die Sprengladung platziert wird
if ((nearestObject [_pos, _vaultHouse]) getVariable ["locked", true]) exitWith { hint localize "STR_ISTR_Blast_Exploit"; };

// Versuche, die Sprengladung dem Inventar hinzuzufügen
if (!([false, "blastingcharge", 1] call life_fnc_handleInv)) exitWith { hint localize "STR_ISTR_Blast_Error"; };

// Setze die Variable für die platzierte Sprengladung
_vault setVariable ["chargeplaced", true, true];

// Sende eine Nachricht an die Polizisten über den Broadcast-Mechanismus
[0, "STR_ISTR_Blast_Placed", true, []] remoteExecCall ["life_fnc_broadcast", west];

// Zeige eine Benachrichtigung an alle Spieler, um sich fernzuhalten
hint localize "STR_ISTR_Blast_KeepOff";

// Starte den Demo-Charge-Timer und den Handle für die Sprengladung
[] remoteExec ["life_fnc_demoChargeTimer", [west, player]];
[] remoteExec ["TON_fnc_handleBlastingCharge", 2];
