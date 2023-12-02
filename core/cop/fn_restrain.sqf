#include "..\..\script_macros.hpp"
/*
    File: fn_restrain.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Restrains the client.
*/

// Parameter definieren
params [
    ["_cop", objNull, [objNull]]
];

// Überprüfen, ob der _cop ungültig ist
if (isNull _cop) exitWith {};

// Überwacht übermäßige Festnahme
[] spawn {
    private "_time";
    for "_i" from 0 to 1 step 0 do {
        _time = time;
        waitUntil {time - _time > (5 * 60)};

        // Überprüfen, ob der Spieler gefesselt ist, keine nahe Einheit ist und nicht in einem Fahrzeug ist
        if !(player getVariable ["restrained", false]) exitWith {};
        if (!([west, getPos player, 30] call life_fnc_nearUnits) && {player getVariable ["restrained", false]} && {isNull objectParent player}) exitWith {
            player setVariable ["restrained", false, true];
            player setVariable ["Escorting", false, true];
            player setVariable ["transporting", false, true];
            detach player;
            titleText[localize "STR_Cop_ExcessiveRestrain", "PLAIN"];
        };
    };
};

// Meldung anzeigen, dass der Spieler gefesselt ist
titleText[format [localize "STR_Cop_Restrained", _cop getVariable ["realname", name _cop]], "PLAIN"];

// Benutzereingabe während der Festnahme deaktivieren
life_disable_getIn = true;
life_disable_getOut = false;

// Hauptschleife für die Festnahme
while {player getVariable ["restrained", false]} do {
    if (isNull objectParent player) then {
        // Spieler bewegt sich, wenn er nicht in einem Fahrzeug ist
        player playMove "AmovPercMstpSnonWnonDnon_Ease";
    };

    private _state = vehicle player;
    waitUntil {
        animationState player != "AmovPercMstpSnonWnonDnon_Ease" ||
        {!(player getVariable ["restrained", false])} ||
        {vehicle player != _state}
    };

    // Beenden, wenn der Spieler nicht mehr lebt
    if (!alive player) exitWith {
        player setVariable ["restrained", false, true];
        player setVariable ["Escorting", false, true];
        player setVariable ["transporting", false, true];
        detach player;
    };

    // Beenden, wenn der _cop nicht mehr lebt
    if (!alive _cop) then {
        player setVariable ["Escorting", false, true];
        detach player;
    };

    // Eject-Aktion auslösen, wenn der Spieler in einem Fahrzeug ist und life_disable_getIn aktiviert ist
    if (!(isNull objectParent player) && {life_disable_getIn}) then {
        player action["eject", vehicle player];
    };

    // Aktualisieren Sie _vehicle, wenn der Spieler ein anderes Fahrzeug betritt
    if (!(isNull objectParent player) && {!(vehicle player isEqualTo _vehicle)}) then {
        _vehicle = vehicle player;
    };

    // Spieler in das Fahrzeug einsteigen lassen, wenn er nicht in einem Fahrzeug ist und life_disable_getOut aktiviert ist
    if (isNull objectParent player && {life_disable_getOut}) then {
        player moveInCargo _vehicle;
    };

    // Eject-Aktion auslösen und in das Fahrzeug einsteigen lassen, wenn der Spieler der Fahrer ist und life_disable_getOut aktiviert ist
    if (!(isNull objectParent player) && {life_disable_getOut} && {driver (vehicle player) isEqualTo player}) then {
        player action["eject", vehicle player];
        player moveInCargo _vehicle;
    };

    // Eject-Aktion auslösen und in das Fahrzeug einsteigen lassen, wenn life_disable_getOut aktiviert ist
    if (!(isNull objectParent player) && {life_disable_getOut}) then {
        _turrets = [[-1]] + allTurrets _vehicle;
        {
            if (_vehicle turretUnit [_x select 0] isEqualTo player) then {
                player action["eject", vehicle player];
                sleep 1;
                player moveInCargo _vehicle;
            };
            true
        } count _turrets;
    };
};

// Benutzereingabe aktivieren, wenn der Spieler nicht mehr gefesselt ist
life_disable_getIn = false;
life_disable_getOut = false;

// Spieleranimation ändern und von Objekt abtrennen, wenn er noch lebt
if (alive player) then {
    player switchMove "AmovPercMstpSlowWrflDnon_SaluteIn";
    player setVariable ["Escorting", false, true];
    player setVariable ["transporting", false, true];
    detach player;
};
