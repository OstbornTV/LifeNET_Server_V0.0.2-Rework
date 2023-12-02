#include "..\..\script_macros.hpp"
/*
    File: fn_pullOutVeh.sqf
    Author: Bryan "Tonic" Boardwine

    Description: Handles pulling a player out of a vehicle.
    Beschreibung: Behandelt das Herausziehen eines Spielers aus einem Fahrzeug.
*/

// Private Variable für die Benachrichtigung
private ["_notification"];

// Verwende Konstanten, um magische Zahlen zu vermeiden
#define PULLED_OUT_NOTIFICATION "STR_NOTF_PulledOut"

// Überprüfe, ob die Fraktion des Spielers westlich ist oder ob der Spieler kein übergeordnetes Objekt hat
if (playerSide isEqualTo west || (isNull objectParent player)) exitWith {};

// Überprüfe, ob der Spieler gefesselt ist
if (player getVariable "restrained") then {
    // Spieler abtrennen
    detach player;
    // Variable "Escorting" auf false setzen
    player setVariable ["Escorting", false, true];
    // Variable "transporting" auf false setzen
    player setVariable ["transporting", false, true];
    // Setze "life_disable_getOut" auf false
    life_disable_getOut = false;
    // Spieler aus dem Fahrzeug werfen
    player action ["Eject", vehicle player];
    // Benachrichtigung
    _notification = localize PULLED_OUT_NOTIFICATION;
    titleText[_notification, "PLAIN"];
    titleFadeOut 4;
    // Setze "life_disable_getIn" auf true
    life_disable_getIn = true;
} else {
    // Spieler aus dem Fahrzeug werfen
    player action ["Eject", vehicle player];
    // Benachrichtigung
    _notification = localize PULLED_OUT_NOTIFICATION;
    titleText[_notification, "PLAIN"];
    titleFadeOut 4;
};
