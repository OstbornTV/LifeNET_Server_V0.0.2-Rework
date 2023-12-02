#include "..\..\script_macros.hpp"

/*
    File: fn_rubbellos.sqf
    Author: Natic
    Zeile 39 nur verwendbar mit dem CarSpawn script
*/

private ["_winner"];

// Inventar schließen
closeDialog 0;

// Überprüfen, ob das Rubbellos im Inventar vorhanden ist
if (!([false,"rubbellos",1] call life_fnc_handleInv)) exitWith {};

// Mitteilung über das Rubbeln anzeigen
titleText["Du rubbelst dein Rubbellos und...","PLAIN"];
sleep 3;

// Zufällige Zahl zwischen 0 und 49 generieren
_winner = floor(random(50));

// Überprüfen, welche Zahl gewonnen hat
if (_winner < 45) exitWith {
    titleText["Leider eine Niete :( Das war leider Pech, versuche es nochmal!","PLAIN"];
};

if (_winner == 45) exitWith {
    // Gewinn: $150
    titleText["Du hast 150$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 150;
};

if (_winner == 46) exitWith {
    // Gewinn: $350
    titleText["Du hast 350$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 350;
};

if (_winner == 47) exitWith {
    // Gewinn: $750
    titleText["Du hast 750$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 750;
};

if (_winner == 48) exitWith {
    // Gewinn: $2000
    titleText["Du hast 2000$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 2000;
};

if (_winner == 49) exitWith {
    // Gewinn: $5000
    titleText["Du hast 5000$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 5000;
};

if (_winner == 50) exitWith {
    // Gewinn: $7500
    titleText["Du hast 7500$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
    CASH = CASH + 7500;
};
