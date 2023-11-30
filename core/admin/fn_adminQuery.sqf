#include "..\..\script_macros.hpp"
/*
    File: fn_adminQuery.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Startet die Abfrage eines Spielers.
*/

// Deaktiviert die Serialisierung
disableSerialization;

// Überprüft, ob eine Abfrage bereits im Gange ist, und gibt eine Meldung aus
if (!isNil "admin_query_ip") exitWith {
    hint localize "STR_ANOTF_Query_2";
};

// Holt den ausgewählten Spieler aus der Liste
private _text = CONTROL(2900, 2903);
private _info = lbData[2902, lbCurSel (2902)];
_info = call compile format ["%1", _info];

// Beendet die Ausführung, wenn keine gültigen Spielerinformationen vorliegen
if (isNil "_info" || {isNull _info}) exitWith {_text ctrlSetText localize "STR_ANOTF_QueryFail"};

// Ruft die Funktion zur Spielerabfrage auf dem Server auf
remoteExecCall ["life_util_fnc_playerQuery", _info];

// Aktualisiert den Text im Dialogfenster
_text ctrlSetText localize "STR_ANOTF_Query";
