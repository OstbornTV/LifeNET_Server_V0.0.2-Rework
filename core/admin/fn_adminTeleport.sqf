#include "..\..\script_macros.hpp"
/*
    File: fn_adminTeleport.sqf
    Author: ColinM9991
    Credits: To original script author(s)
    Description:
    Teleports to the chosen position.
*/

// Überprüft das Admin-Level für die Ausführung dieser Aktion
if (FETCH_CONST(life_adminlevel) < 3) exitWith {closeDialog 0;};

// Schließt das Dialogfenster
closeDialog 0;

// Öffnet die Karte im Teleportmodus und fügt einen EventHandler für den Kartenklick hinzu
openMap [true, false];
onMapSingleClick "_pos call life_fnc_teleport";