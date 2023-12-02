#include "..\..\script_macros.hpp"
/*
    File: fn_radar.sqf
    Author: Silly Aussie kid named Jaydon
    Description:
    Radar
*/

// Überprüfen Sie, ob der Spieler auf der Seite der West-Fraktion ist
if !(playerSide isEqualTo west) exitWith {};

// Holen Sie sich das aktuell ausgerichtete Objekt des Cursors (CursorObject)
private _vehicle = cursorObject;

// Überprüfen Sie, ob das Fahrzeug eine Art von "Car" ist und der Spieler eine Pistole mit Schalldämpfer (hgun_P07_snds_F) hält
if (_vehicle isKindOf "Car" && {currentWeapon player isEqualTo "hgun_P07_snds_F"}) then {
    private _speed = round speed _vehicle;

    // Überprüfen Sie die Geschwindigkeit des Fahrzeugs und geben Sie entsprechende Hinweise aus
    if (_speed > 80) then {
        hint parseText format ["<t color='#ffffff'><t size='2'><t align='center'>" + (localize "STR_Cop_Radar")+ "<br/><t color='#FF0000'><t align='center'><t size='1'>" + (localize "STR_Cop_VehSpeed"), _speed];
    } else {
        if (_speed > 33) then {
            hint parseText format ["<t color='#ffffff'><t size='2'><t align='center'>" + (localize "STR_Cop_Radar")+ "<br/><t color='#33CC33'><t align='center'><t size='1'>" + (localize "STR_Cop_VehSpeed"), _speed];
        };
    };
};
