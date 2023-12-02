#include "..\..\script_macros.hpp"
/*
    File: fn_gangCreated.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Informiert den Spieler darüber, dass die Gang erstellt wurde, und fügt ihn hinzu.
*/
life_action_gangInUse = nil;

// Überprüfen Sie, ob der Spieler genügend Geld hat, um die Gang zu erstellen
if (BANK < (LIFE_SETTINGS(getNumber,"gang_price"))) exitWith {
    // Zeige einen Hinweis an, dass nicht genügend Geld vorhanden ist
    hint format [localize "STR_GNOTF_NotEnoughMoney",[((LIFE_SETTINGS(getNumber,"gang_price"))-BANK)] call life_fnc_numberText];
    
    // Lösche alle Gang-Verwandten Spielerdaten
    {group player setVariable [_x,nil,true];} forEach ["gang_id","gang_owner","gang_name","gang_members","gang_maxmembers","gang_bank"];
};

// Ziehe den Preis für die Gang vom Bankguthaben ab und aktualisiere die Anzeige
BANK = BANK - LIFE_SETTINGS(getNumber,"gang_price");
[1] call SOCK_fnc_updatePartial;

// Zeige einen Hinweis an, dass die Gang erfolgreich erstellt wurde
hint format [localize "STR_GNOTF_CreateSuccess",(group player) getVariable "gang_name",[(LIFE_SETTINGS(getNumber,"gang_price"))] call life_fnc_numberText];