#include "..\..\script_macros.hpp"
/*
    File: fn_tazedRubber.sqf
    Author: Skalicon modded by Mahribar
    Further modded and updated to 5.0 by Edward Cullen
    
    Description: Downed state for rubber bullets
*/
private["_curWep","_curMags","_attach"];
params [
    ["_unit",objNull,[objNull]],
    ["_shooter",objNull,[objNull]]
];

// Überprüfen, ob _unit oder _shooter null sind
if(isNull _unit OR isNull _shooter) exitWith {player allowDamage true; life_isdowned = false;};

// Überprüfen, ob _shooter eine Einheit ist und der Spieler lebt
if(_shooter isKindOf "Man" && alive player) then {
    // Überprüfen, ob der Spieler bereits downed ist
    if(!life_isdowned) then {
        life_isdowned = true;

        // Spieler leicht verletzen
        player setDamage 0.5;

        // Waffen und Magazine des Spielers sichern
        _curWep = currentWeapon player;
        _curMags = magazines player;
        _attach = if(primaryWeapon player != "") then {primaryWeaponItems _unit} else {[]};

        // Magazine entfernen
        {player removeMagazine _x} foreach _curMags;

        // Waffe entfernen und wieder hinzufügen
        player removeWeapon _curWep;
        player addWeapon _curWep;

        // Zusätzliche Waffen-Attachments wieder hinzufügen
        if(count _attach != 0 && primaryWeapon _unit != "") then {
            {
                _unit addPrimaryWeaponItem _x;
            } foreach _attach;
        };

        // Magazines wieder hinzufügen
        if(count _curMags != 0) then {
            {player addMagazine _x;} foreach _curMags;
        };

        // Dummy-Objekt erstellen und Spieler daran befestigen
        _obj = "Land_ClutterCutter_small_F" createVehicle (getPosATL _unit);
        _obj setPosATL (getPosATL _unit);
        [player,"AinjPfalMstpSnonWnonDf_carried_fallwc"] remoteExecCall ["life_fnc_animSync",RCLIENT];
        [0,"STR_NOTF_Rubber",true,[profileName, _shooter getVariable ["realname",name _shooter]]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
        _unit attachTo [_obj,[0,0,0]];
        disableUserInput true;
        sleep 8;

        // Wenn nicht gefesselt, Animation fortsetzen
        if(!(player getVariable "restrained")) then {
            [player,"AinjPpneMstpSnonWrflDnon"] remoteExecCall ["life_fnc_animSync",RCLIENT];
            sleep 22;
        }

        // "disableUserInput" alle 15 Sekunden überprüfen, um aufzuwecken
        for "_i" from 0 to 3 do {
            if(!(player getVariable "restrained")) then {
                sleep 15;
            };
        };

        // Wenn nicht gefesselt, Abschlussanimation und Benutzersteuerung aktivieren
        if (!(player getVariable "restrained")) then {
            [player,"amovppnemstpsraswrfldnon"] remoteExecCall ["life_fnc_animSync",RCLIENT];
        };

        disableUserInput false;
        detach player;
        life_isdowned = false;
        player allowDamage true;
    };
} else {
    // _shooter ist keine Einheit oder Spieler ist nicht lebendig
    _unit allowDamage true;
    life_isdowned = false;
};
