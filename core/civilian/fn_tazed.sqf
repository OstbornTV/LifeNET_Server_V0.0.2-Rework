#include "..\..\script_macros.hpp"
/*
    File: fn_tazed.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Startet die Tased-Animation und sendet die erforderlichen Informationen.
*/

params [
    ["_unit", objNull, [objNull]],
    ["_shooter", objNull, [objNull]]
];

// Überprüfen, ob _unit oder _shooter null sind
if (isNull _unit || {isNull _shooter}) exitWith {
    player allowDamage true;
    life_istazed = false;
};

// Überprüfen, ob _shooter eine Einheit ist und der Spieler lebt
if (_shooter isKindOf "Man" && {alive player}) then {
    // Überprüfen, ob der Spieler bereits getazed ist
    if (!life_istazed) then {
        life_istazed = true;

        // Waffen und Magazine des Spielers sichern
        private _curWep = currentWeapon player;
        private _curMags = magazines player;
        private _attach = if (!(primaryWeapon player isEqualTo "")) then {primaryWeaponItems player} else {[]};

        // Magazine entfernen
        {
            player removeMagazine _x;
        } count _curMags;

        // Waffe entfernen und wieder hinzufügen
        player removeWeapon _curWep;
        player addWeapon _curWep;

        // Zusätzliche Waffen-Attachments wieder hinzufügen
        if (!(_attach isEqualTo []) && {!(primaryWeapon player isEqualTo "")}) then {
            {
                _unit addPrimaryWeaponItem _x;
            } count _attach;
        };

        // Magazines wieder hinzufügen
        if !(_curMags isEqualTo []) then {
            {
                player addMagazine _x;
            } count _curMags;
        };

        // Taser-Sound abspielen
        [_unit, "tazerSound", 100, 1] remoteExecCall ["life_fnc_say3D", RCLIENT];

        // Dummy-Objekt erstellen und Spieler daran befestigen
        private _obj = "Land_ClutterCutter_small_F" createVehicle ASLTOATL (visiblePositionASL player);
        _obj setPosATL ASLTOATL (visiblePositionASL player);
        _unit attachTo [_obj, [0, 0, 0]];

        // Taser-Animation und Broadcast starten
        [player, "AinjPfalMstpSnonWnonDf_carried_fallwc"] remoteExecCall ["life_fnc_animSync", RCLIENT];
        [0, "STR_NOTF_Tazed", true, [profileName, _shooter getVariable ["realname", name _shooter]]] remoteExecCall ["life_fnc_broadcast", RCLIENT];

        // Benutzereingabe deaktivieren und warten
        disableUserInput true;
        sleep 15;

        // Spieler-Animation aktualisieren
        [player, "AmovPpneMstpSrasWrflDnon"] remoteExecCall ["life_fnc_animSync", RCLIENT];

        // Spieler von Dummy-Objekt trennen, wenn er nicht eskortiert wird
        if !(player getVariable ["Escorting", false]) then {
            detach player;
        };

        // Zurücksetzen der Taser-Flags und ermöglichen von Schaden und Benutzereingabe
        life_istazed = false;
        player allowDamage true;
        disableUserInput false;
    };
} else {
    // _shooter ist keine Einheit oder Spieler ist nicht lebendig
    _unit allowDamage true;
    life_istazed = false;
};