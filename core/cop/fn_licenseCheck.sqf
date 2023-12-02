#include "..\..\script_macros.hpp"
/*
    File: fn_licenseCheck.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Returns the licenses to the cop.
*/

params [
    ["_cop", objNull, [objNull]]
];

if (isNull _cop) exitWith { /* Meldung, wenn ungültiger Eintrag */ }; 

private _licenses = ""; // String zur Speicherung der Lizenzen

// Config-Einträge für Lizenzen, die Zivilisten gehören
private _licensesConfigs = "getText(_x >> 'side') isEqualTo 'civ'" configClasses (missionConfigFile >> "Licenses");

{
    // Überprüfen, ob die Lizenz für Zivilisten gültig ist
    if (LICENSE_VALUE(configName _x, "civ")) then {
        _licenses = _licenses + getText(_x >> "displayName") + "<br/>"; // Lizenz zum String hinzufügen
    };
    true
} count _licensesConfigs;

if (_licenses isEqualTo "") then {
    _licenses = localize "STR_Cop_NoLicensesFound"; // Meldung, wenn keine Lizenzen gefunden wurden
};
[profileName, _licenses] remoteExecCall ["life_fnc_licensesRead", _cop]; // Lizenzinformationen an den Cop senden
