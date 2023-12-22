#include "..\..\script_macros.hpp"
/*
    File: fn_safeInventory.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Fills up the safes inventory.
*/

// Parameter deklarieren und standardmäßige Werte festlegen
params [
    ["_safe", objNull, [objNull]]
];

// Überprüfen, ob der Tresor existiert
if (isNull _safe) exitWith { closeDialog 0; };

// Serialisierung deaktivieren
disableSerialization;

// Safes-Inventar-Listbox zurücksetzen
private _tInv = (findDisplay 3500) displayCtrl 3502;
lbClear _tInv;

// Safe-Informationen abrufen
private _safeInfo = _safe getVariable ["safe", -1];

// Überprüfen, ob der Safe leer ist
if (_safeInfo < 1) exitWith { closeDialog 0; hint localize "STR_Civ_VaultEmpty"; };

// Informationen für goldbar aus der Konfiguration abrufen
private _str = M_CONFIG(getText, "VirtualItems", "goldbar", "displayName");
private _shrt = M_CONFIG(getText, "VirtualItems", "goldbar", "variable");
private _icon = M_CONFIG(getText, "VirtualItems", "goldbar", "icon");

// Eintrag für goldbar in der Listbox erstellen
private _id = _tInv lbAdd format ["[%1] - %2", _safeInfo, _str];
_tInv lbSetData [_id, _shrt];

// Bild für goldbar setzen, falls vorhanden
if !(_icon isEqualTo "") then {
    _tInv lbSetPicture [_id, _icon];
};
