#include "..\..\script_macros.hpp"
/*
    File: fn_questionDealer.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Questions the drug dealer and sets the sellers wanted.
*/

params [
    ["_dealer", objNull, [objNull]] // Parameter für den Dealer (leerer Standardwert)
];

// Holen Sie sich die Verkäufer des Dealers
private _sellers = _dealer getVariable ["sellers", []];

// Wenn keine Verkäufer vorhanden sind, beenden Sie den Vorgang
if (_sellers isEqualTo []) exitWith {
    hint localize "STR_Cop_DealerQuestion";
};

life_action_inUse = true; // Markieren Sie, dass eine Aktion im Gange ist
private _crimes = LIFE_SETTINGS(getArray,"crimes"); // Holen Sie sich die Liste der Verbrechen

private _names = "";
{
    _x params ["_uid","_name","_value"];
    private _val = 0;

    // Überprüfen Sie den Wert des Verkaufs und berechnen Sie das Verbrechen basierend darauf
    if (_value > 150000) then {
        _val = round(_value / 16);
    } else {
        _val = ["483",_crimes] call life_util_fnc_index;
        _val = ((_crimes select _val) select 1);
        if (_val isEqualType "") then {
            _val = parseNumber _val;
        };
    };

    // Fügen Sie den Verkäufer zur Fahndungsliste hinzu
    [_uid, _name, "483", _val] remoteExecCall ["life_fnc_wantedAdd", RSERV];
    _names = _names + format ["%1<br/>", _name];

    true
} count _sellers;

// Benachrichtigung über den erfolgreichen Abschluss
hint parseText format [(localize "STR_Cop_DealerMSG") + "<br/><br/>%1", _names];
_dealer setVariable ["sellers", [], true]; // Leeren Sie die Verkäuferliste des Dealers
life_action_inUse = false; // Markieren Sie, dass die Aktion abgeschlossen ist
