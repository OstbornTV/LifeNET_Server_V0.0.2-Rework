#include "..\..\script_macros.hpp"
/*
    File: fn_cellphone.sqf
    Author: Alan

    Description:
    Opens the cellphone menu?
*/
private ["_display","_units","_type"];

disableSerialization;
waitUntil {!isNull findDisplay 3000};
_display = findDisplay 3000;
_units = _display displayCtrl 3004;

ctrlSetText [3003, ""];
lbClear _units;

// Überprüfen, ob der Spieler mit ACE gefesselt ist oder sich ergeben hat
if ((player getVariable["ace_restrained", false] && getVariable["restrained", false]) || (player getVariable["ace_surrender", false] && getVariable["surrender", false])) exitWith {hint "Du bist gefesselt oder hast dich ergeben!";};

if (FETCH_CONST(life_adminlevel) < 1) then {
    ctrlShow[3020,false];
    ctrlShow[3021,false];
};
{
    // Überprüfen, ob die Einheit lebendig ist und nicht der Spieler selbst ist
    if (alive _x && !(_x isEqualTo player)) then {
        _type = switch (side _x) do {
            case west: {"Cop"};
            case civilian: {"Civ"};
            case independent: {"Med"};
        };
        _units lbAdd format ["%1 (%2)",_x getVariable ["realname",name _x],_type];
        _units lbSetData [(lbSize _units)-1,str(_x)];
    };
} forEach playableUnits;

lbSetCurSel [3004,0];
