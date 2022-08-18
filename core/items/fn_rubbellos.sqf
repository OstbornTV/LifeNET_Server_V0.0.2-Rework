#include "..\..\script_macros.hpp"
/*
 File: fn_rubbellos.sqf
 Author: Natic
 Zeile 39 nur verwendbar mit dem CarSpawn script
*/
private["_winner"];
//Close inventory
closeDialog 0;
if(!([false,"rubbellos",1] call life_fnc_handleInv)) exitWith {};titleText["Du rubbelst dein Rubbellos und...","PLAIN"];
sleep 3;
_winner = floor(random(50));
if(_winner < 45) exitWith {
 titleText["Leider eine Niete :( Das war leider Pech, versuche es nochmal!","PLAIN"]; 
};
if(_winner == 45) exitWith {
 titleText["Du hast 150$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 150;
};
if(_winner == 46) exitWith {
 titleText["Du hast 350$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 350;
};
if(_winner == 47) exitWith {
 titleText["Du hast 750$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 750;
};
if(_winner == 48) exitWith {
 titleText["Du hast 2000$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 2000;
};
if(_winner == 49) exitWith {
 titleText["Du hast 5000$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 5000;
};
if(_winner == 50) exitWith {
 titleText["Du hast 7500$ gewonnen. Herzlichen Glückwunsch!","PLAIN"];
 CASH = CASH + 7500;
 //[true,"carspawn",1] call life_fnc_handleInv;
}; 