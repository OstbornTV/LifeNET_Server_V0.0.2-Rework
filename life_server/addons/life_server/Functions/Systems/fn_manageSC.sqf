/*
    File: fn_manageSC.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    User management of whether or not they want to be on a sidechat for their side.
*/
private ["_unit", "_bool", "_side"];
_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_bool = [_this, 1, false, [false]] call BIS_fnc_param;
_side = [_this, 2, civilian, [west]] call BIS_fnc_param;

if (isNull _unit) exitWith {};

// Verwende switch-Case für unterschiedliche Seiten
switch _side do {
    case west: {
        // Füge oder entferne den Benutzer aus dem West-Sidechat hinzu
        if (_bool) then {
            life_radio_west radioChannelAdd [_unit];
        } else {
            life_radio_west radioChannelRemove [_unit];
        };
    };

    case civilian: {
        // Füge oder entferne den Benutzer aus dem Civilian-Sidechat hinzu
        if (_bool) then {
            life_radio_civ radioChannelAdd [_unit];
        } else {
            life_radio_civ radioChannelRemove [_unit];
        };
    };

    case independent: {
        // Füge oder entferne den Benutzer aus dem Independent-Sidechat hinzu
        if (_bool) then {
            life_radio_indep radioChannelAdd [_unit];
        } else {
            life_radio_indep radioChannelRemove [_unit];
        };
    };
};
