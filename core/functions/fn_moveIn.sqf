/*
    File: moveIn.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Set a variable on the player so that he can't get out of a vehicle
*/

// Variable, die das Einsteigen des Spielers deaktiviert
life_disable_getIn = false;

// Spieler in den Frachtraum des Fahrzeugs bewegen
player moveInCargo (_this select 0);

// Variable, die das Aussteigen des Spielers aktiviert
life_disable_getOut = true;
