#include "..\..\script_macros.hpp"
/*
    File: fn_licensesRead.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Outprints the licenses.
*/

params [
    ["_civ", "", [""]],        // Parameter für den Zivilisten (leerer Standardwert)
    ["_licenses", "", [""]]    // Parameter für die Lizenzen (leerer Standardwert)
];

// Ausgabe der Lizenzinformationen als Benachrichtigung
hint parseText format ["<t color='#FF0000'><t size='2'>%1</t></t><br/><t color='#FFD700'><t size='1.5'>" + (localize "STR_Cop_Licenses")+ "</t></t><br/>%2", _civ, _licenses];
