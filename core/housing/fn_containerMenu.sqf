#include "..\..\script_macros.hpp"
/*
    File: fn_containerMenu.sqf
    Author: NiiRoZz

    Description:
    Container-Interaktionsmenü.
*/
#define Btn1 37450
#define Btn2 37451
#define Btn3 37452
#define Btn4 37453
#define Btn5 37454
#define Btn6 37455
#define Btn7 37456
#define Btn8 37457
#define Title 37401

// Deklariere lokale Variablen
private ["_container","_Btn1","_Btn2","_Btn3","_Btn4","_Btn5","_Btn6","_Btn7","_Btn8"];
// Deaktiviere Serialisierung
disableSerialization;
// Hole den übergebenen Container-Parameter
_container = param [0,objNull,[objNull]];
// Überprüfe, ob der Container ungültig ist
if (isNull _container) exitWith {}; // Schlechtes Ziel

// Erstelle das Dialogfeld, wenn es noch nicht vorhanden ist
if (!dialog) then {
    createDialog "pInteraction_Menu";
}

// Definiere die Steuerelemente für die Menüschaltflächen
_Btn1 = CONTROL(37400,Btn1);
_Btn2 = CONTROL(37400,Btn2);
_Btn3 = CONTROL(37400,Btn3);
_Btn4 = CONTROL(37400,Btn4);
_Btn5 = CONTROL(37400,Btn5);
_Btn6 = CONTROL(37400,Btn6);
_Btn7 = CONTROL(37400,Btn7);
_Btn8 = CONTROL(37400,Btn8);
// Verstecke alle Menüschaltflächen zu Beginn
{_x ctrlShow false;} forEach [_Btn1,_Btn2,_Btn3,_Btn4,_Btn5,_Btn6,_Btn7,_Btn8];

// Setze die globale Variable "life_pInact_container" auf den aktuellen Container
life_pInact_container = _container;

// Überprüfe die Fraktion des Spielers
if (playerSide isEqualTo west) then {
    // Wenn der Spieler westlich ist, zeige die Schaltfläche "STR_vInAct_SearchContainer" an
    _Btn1 ctrlSetText localize "STR_vInAct_SearchContainer";
    // Setze die Aktion für die Schaltfläche "STR_vInAct_SearchContainer"
    _Btn1 buttonSetAction "[life_pInact_container] spawn life_fnc_containerInvSearch; closeDialog 0;";
    // Zeige die Schaltfläche "STR_vInAct_SearchContainer" an
    _Btn1 ctrlShow true;
} else {
    // Wenn der Spieler nicht westlich ist, zeige die Schaltfläche "STR_pInAct_RemoveContainer" an
    _Btn1 ctrlSetText localize "STR_pInAct_RemoveContainer";
    // Setze die Aktion für die Schaltfläche "STR_pInAct_RemoveContainer"
    _Btn1 buttonSetAction "[life_pInact_container] spawn life_fnc_removeContainer; closeDialog 0;";
    // Zeige die Schaltfläche "STR_pInAct_RemoveContainer" an
    _Btn1 ctrlShow true;
};
