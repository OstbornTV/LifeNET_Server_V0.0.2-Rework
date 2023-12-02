#include "..\..\script_macros.hpp"
/*
    File: fn_gangDisbanded.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Informiert die Mitglieder darüber, dass die Gang aufgelöst wurde.
*/
// Überprüfe, ob die Gruppe vorhanden ist
private _group = param [0,grpNull,[grpNull]];
if (isNull _group) exitWith {}; // Beende den Code, wenn die Gruppe nicht vorhanden ist (Fehlermeldung)

// Schließe das Gang-Auflösungs-Dialogfeld, falls geöffnet
if (!isNull (findDisplay 2620)) then {closeDialog 2620};

// Zeige einen Hinweis an, dass die Gang aufgelöst wurde
hint localize "STR_GNOTF_DisbandWarn_2";

// Erstelle eine neue Gruppe für den Spieler und füge den Spieler der neuen Gruppe hinzu
private _newGroup = createGroup civilian;
[player] joinSilent _newGroup;

// Setze die Option, die Gruppe zu löschen, wenn sie leer ist
_newGroup deleteGroupWhenEmpty true;
