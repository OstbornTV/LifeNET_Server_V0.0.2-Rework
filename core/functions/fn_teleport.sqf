/*
    File: fn_teleport.sqf
    Author: ColinM9991
    Credits: To original script author(s)

    Description:
    Teleportiere zu der ausgewählten Position.
*/
private ["_pos"];

// Extrahiere die Position aus den übergebenen Parametern
_pos = [_this select 0, _this select 1, _this select 2];

// Setze die Position des Fahrzeugs des Spielers auf die ausgewählte Position
(vehicle player) setPos [_pos select 0, _pos select 1, 0];

// Setze den Karten-Klick-Effekt zurück
onMapSingleClick "";

// Schließe die Karte
openMap [false, false];

// Zeige eine Benachrichtigung an, dass der Spieler teleportiert wurde
hint localize "STR_NOTF_Teleport";
