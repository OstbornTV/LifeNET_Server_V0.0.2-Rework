#include "..\..\script_macros.hpp"
/*
    File: fn_unrestrain.sqf
    Author:

    Description:

*/

params [
    ["_unit", objNull, [objNull]]
];

// Überprüfen, ob das Zielobjekt vorhanden ist und eingeschränkt ist
if (isNull _unit || !(_unit getVariable ["restrained", false])) exitWith {};

// Aufheben der Fesselung und Begleitfunktionen deaktivieren
_unit setVariable ["restrained", false, true];
_unit setVariable ["Escorting", false, true];
_unit setVariable ["transporting", false, true];
detach _unit;

// Rundfunknachricht über die Aufhebung der Fesselung senden
[0, "STR_NOTF_Unrestrain", true, [_unit getVariable ["realname", name _unit], profileName]] remoteExecCall ["life_fnc_broadcast", west];
