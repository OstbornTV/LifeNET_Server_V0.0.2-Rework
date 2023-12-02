#include "..\..\script_macros.hpp"
/*
    File: fn_knockedOut.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Startet und überwacht den Zustand "außer Gefecht gesetzt".
*/

params [
    ["_target", objNull, [objNull]],
    ["_who", "", [""]]
];

// Überprüfen, ob das Zielobjekt und der Name gültig sind
if (isNull _target || {_who isEqualTo ""}) exitWith {};
// Überprüfen, ob das Zielobjekt mit dem Spieler übereinstimmt
if !(_target isEqualTo player) exitWith {};

// Anzeigen einer Benachrichtigung, dass der Spieler außer Gefecht gesetzt ist
titleText [format [localize "STR_Civ_KnockedOut", _who], "PLAIN"];
// Abspielen der "Incapacitated"-Bewegung
player playMoveNow "Incapacitated";
// Deaktivieren der Benutzereingabe
disableUserInput true;

// Erstellen eines virtuellen Objekts ("ClutterCutter_small") und Positionieren es an der aktuellen Position des Spielers
private _obj = "Land_ClutterCutter_small_F" createVehicle ASLTOATL (visiblePositionASL player);
_obj setPosATL ASLTOATL (visiblePositionASL player);

// Setzen des Status "außer Gefecht gesetzt" auf true und Anhängen des Spielers an das erstellte Objekt
life_isknocked = true;
player attachTo [_obj, [0, 0, 0]];

// Warten für 15 Sekunden
sleep 15;

// Abspielen der "AmovPpneMstpSrasWrflDnon"-Bewegung
player playMoveNow "AmovPpneMstpSrasWrflDnon";
// Aktivieren der Benutzereingabe
disableUserInput false;
// Ablösen des Spielers vom Objekt und Löschen des Objekts
detach player;
deleteVehicle _obj;

// Setzen des Status "außer Gefecht gesetzt" auf false und Setzen des Spielerattributs "robbed" auf false
life_isknocked = false;
player setVariable ["robbed", false, true];
