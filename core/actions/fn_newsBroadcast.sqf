#include "..\..\script_macros.hpp"
/*
    File: fn_newsBroadcast.sqf
    Author: Jesse "tkcjesse" Schultz

    Description:
    Creates the dialog and handles the data in the Channel 7 News Dialog.
*/

// Überprüfe, ob das Dialogfeld existiert, wenn nicht, erstelle es
if !(dialog) then {
    createDialog "life_news_broadcast";
}

disableSerialization;
private _display = findDisplay 100100;
private _confirmBtn = _display displayCtrl 100104;
_confirmBtn ctrlEnable false;

// Zeitbasierte Einstellungen für die Nachrichtenübertragung
private _msgCooldown = 60 * LIFE_SETTINGS(getNumber, "news_broadcast_cooldown");
private _msgCost = LIFE_SETTINGS(getNumber, "news_broadcast_cost");

// Überprüfe, ob der Spieler genug Geld hat, um die Nachrichtenübertragung zu bezahlen
if (CASH < _msgCost) then {
    hint format [localize "STR_News_NotEnough", [_msgCost] call life_fnc_numberText];
} else {
    _confirmBtn ctrlEnable true;
    _confirmBtn buttonSetAction "[] call life_fnc_postNewsBroadcast; closeDialog 0;";
}

private "_broadcastDelay";

// Überprüfe, ob genügend Zeit seit der letzten Nachrichtenübertragung vergangen ist
if (isNil "life_broadcastTimer" || {(time - life_broadcastTimer) > _msgCooldown}) then {
    _broadcastDelay = localize "STR_News_Now";
} else {
    // Wenn nicht genügend Zeit vergangen ist, setze die verbleibende Zeit
    _broadcastDelay = [(_msgCooldown - (time - life_broadcastTimer))] call BIS_fnc_secondsToString;
    _confirmBtn ctrlEnable false;
}

// Aktualisiere die Informationen im Dialogfeld
CONTROL(100100, 100103) ctrlSetStructuredText parseText format [localize "STR_News_StructuredText", [_msgCost] call life_fnc_numberText, _broadcastDelay];
