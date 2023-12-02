#include "..\..\script_macros.hpp"
/*
    File: fn_sellHouseGarage.sqf
    Author: BoGuu
    Description:
    Sell functionality for house garages.
*/

// Überprüfe, ob ein Dialog geöffnet ist, und schließe ihn
if (dialog) then { closeDialog 0 };

// Parametrisiere das Haus und die Spieler-UID
private _house = param [0, objNull, [objNull]];
private _uid = getPlayerUID player;

// Überprüfe, ob das Haus existiert, eine Garage hat und dem Spieler gehört
if (isNull _house) exitWith {};
if !(_house getVariable ["garageBought", false]) exitWith { hint localize "STR_Garage_NotOwned"; };
if ((_house getVariable "house_owner") select 0 != getPlayerUID player) exitWith { hint localize "STR_Garage_NotOwner"; };
closeDialog 0;

// Rufe den Verkaufspreis für die Garage ab
private _sellPrice = LIFE_SETTINGS(getNumber, "houseGarage_sellPrice");

// Zeige eine Bestätigungsnachricht an den Spieler und warte auf die Aktion
_action = [
    format [localize "STR_House_SellGarageMSG",
    [_sellPrice] call life_fnc_numberText],
    localize "STR_House_GarageSell",
    localize "STR_Global_Sell",
    localize "STR_Global_Cancel"
] call BIS_fnc_guiMessage;

if (_action) then {

    // Überprüfe, ob der Verkauf der Garage aufgrund einer Abklingzeit nicht möglich ist
    if (gettingBought > 1) exitWith { hint localize "STR_House_CoolDown"; };

    // Verkaufe die Garage auf dem Headless Client oder Remote Server
    if (life_HC_isActive) then {
        [_uid, _house, 1] remoteExec ["HC_fnc_houseGarage", HC_Life];
    } else {
        [_uid, _house, 1] remoteExec ["TON_fnc_houseGarage", RSERV];
    };

    // Aktualisiere das Bankguthaben und sende eine Teilerneuerung an die Datenbank
    BANK = BANK + _sellPrice;
    [1] call SOCK_fnc_updatePartial;

    // Setze die Garage als nicht gekauft zurück
    _house setVariable ["garageBought", false, true];

};

// Warte 60 Sekunden, bevor ein neuer Kauf möglich ist
sleep 60;
gettingBought = 0;
