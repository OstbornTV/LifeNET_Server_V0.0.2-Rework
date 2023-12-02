#include "..\..\script_macros.hpp"
/*
    File: fn_buyHouseGarage.sqf
    Author: BoGuu
    Description:
    Kauf-Funktionalität für Hausgaragen.
*/

// Deklariere lokale Variablen
private _house = param [0,objNull,[objNull]];
private _uid = getPlayerUID player;

// Überprüfe, ob das Haus ungültig ist
if (isNull _house) exitWith {};
// Überprüfe, ob die Garage bereits gekauft wurde
if (_house getVariable ["garageBought",false]) exitWith {hint localize "STR_Garage_alreadyOwned";};
// Überprüfe, ob der Spieler der Eigentümer des Hauses ist
if ((_house getVariable "house_owner") select 0 != getPlayerUID player) exitWith {hint localize "STR_Garage_NotOwner";};
// Überprüfe, ob die Garage auf der Blacklist steht
if (_house getVariable ["blacklistedGarage",false]) exitWith {};
// Schließe das Dialogfeld
closeDialog 0;

// Holen Sie sich den Preis für den Garagenkauf aus den Einstellungen
private _price = LIFE_SETTINGS(getNumber,"houseGarage_buyPrice");

// Zeige eine Bestätigungsmeldung mit dem Preis der Garage an
_action = [
    format [localize "STR_Garage_HouseBuyMSG",
    [_price] call life_fnc_numberText],
    localize "STR_House_GaragePurchase",
    localize "STR_Global_Buy",
    localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

// Überprüfe, ob der Kauf bestätigt wurde
if (_action) then {

    // Überprüfe, ob der Spieler genügend Geld hat
    if (BANK < _price) exitWith {hint format [localize "STR_House_NotEnough"]};
    // Ziehe den Kaufpreis vom Bankguthaben ab
    BANK = BANK - _price;
    // Aktualisiere die Bankdaten auf dem Server
    [1] call SOCK_fnc_updatePartial;

    // Führe die Funktion für den Garagenkauf aus, abhängig von der Aktivierung des Headless Clients
    if (life_HC_isActive) then {
        [_uid,_house,0] remoteExec ["HC_fnc_houseGarage",HC_Life];
    } else {
        [_uid,_house,0] remoteExec ["TON_fnc_houseGarage",RSERV];
    };

    // Setze die Variable "garageBought" auf "true", um anzuzeigen, dass die Garage gekauft wurde
    _house setVariable ["garageBought",true,true];
};