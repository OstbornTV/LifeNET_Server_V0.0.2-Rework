#include "..\..\script_macros.hpp"
/*
    File: fn_dpFinish.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Finishes the DP Mission and calculates the money earned based
    on distance between A->B
*/
params [
    ["_dp", objNull, [objNull]]
];

// Beende die Lieferung und berechne das verdiente Geld basierend auf der Entfernung
life_delivery_in_progress = false;
life_dp_point = nil;

// Berechne die Entfernung zwischen Startpunkt und Zielpunkt (in Metern)
private _dis = round((getPosATL life_dp_start) distance (getPosATL _dp));

// Berechne den Preis basierend auf der Entfernung
private _price = round(1.7 * _dis);

// Zeige eine Benachrichtigung über den verdienten Betrag
["DeliverySucceeded", [format [(localize "STR_NOTF_Earned_1"), [_price] call life_fnc_numberText]]] call bis_fnc_showNotification;

// Setze den Missionsschritt auf "Erfolgreich"
life_cur_task setTaskState "Succeeded";
player removeSimpleTask life_cur_task;

// Füge das verdiente Geld hinzu
CASH = CASH + _price;
[0] call SOCK_fnc_updatePartial;

// Füge eine zufällige Chance hinzu, dass ein Handwerksplan erstellt wird
[50, 2] call cat_craftingV2_fnc_randomPlan;
