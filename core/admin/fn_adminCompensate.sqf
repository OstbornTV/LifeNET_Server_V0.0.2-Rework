#include "..\..\script_macros.hpp"
/*
    File: fn_adminCompensate.sqf
    Author: ColinM9991

    Description:
    Gibt Kompensationsgeld an den lokalen Spieler
*/

// Überprüfen Sie den Admin-Level
if (FETCH_CONST(life_adminlevel) < 2) exitWith {
    closeDialog 0;
    hint localize "STR_ANOTF_ErrorLevel";
};

// Den Betrag aus dem GUI extrahieren und sicherstellen, dass er gültig ist
private _value = parseNumber(ctrlText 9922);
if (_value < 0) exitWith {};
if (_value > 999999) exitWith {
    hint localize "STR_ANOTF_Fail";
};

// Benutzerwarnung für die Kompensation anzeigen
private _action = [
    format [localize "STR_ANOTF_CompWarn", [_value] call life_fnc_numberText],
    localize "STR_Admin_Compensate",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Wenn der Benutzer zustimmt, führen Sie die Kompensation durch
if (_action) then {
    CASH = CASH + _value;
    hint format [localize "STR_ANOTF_Success", [_value] call life_fnc_numberText];
} else {
    hint localize "STR_NOTF_ActionCancel";
};

closeDialog 0;
