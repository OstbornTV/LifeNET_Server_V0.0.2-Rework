#include "..\..\script_macros.hpp"
/*
    File: fn_copInteractionMenu.sqf
    Author: Bryan "Tonic" Boardwine
    
    Description:
    Replaces the mass addactions for various cop actions towards another player.
*/

// Definiere die Buttons und den Titel
#define BTN_1 37450
#define BTN_2 37451
#define BTN_3 37452
#define BTN_4 37453
#define BTN_5 37454
#define BTN_6 37455
#define BTN_7 37456
#define BTN_8 37457
#define TITLE 37401

// Parameter definieren
params [
    ["_curTarget", objNull, [objNull]]
];

// Serialisierung deaktivieren
disableSerialization;

// Überprüfen, ob der Spieler jemanden eskortiert
if (player getVariable ["Escorting", false]) then {
    // Überprüfen, ob das Zielobjekt gültig ist und sich in der Nähe befindet
    if (isNull _curTarget || {player distance _curTarget > 4}) exitWith {
        closeDialog 0;
    };
    // Überprüfen, ob das Zielobjekt ein ziviler Einheit ist
    if (!isPlayer _curTarget && {side _curTarget isEqualTo civilian}) exitWith {
        closeDialog 0;
    };
}

// Dialog erstellen, wenn nicht vorhanden
if (!dialog) then {
    createDialog "pInteraction_Menu";
}

// Dialog-Elemente abrufen
private _display = findDisplay 37400;
private _btn1 = _display displayCtrl BTN_1;
private _btn2 = _display displayCtrl BTN_2;
private _btn3 = _display displayCtrl BTN_3;
private _btn4 = _display displayCtrl BTN_4;
private _btn5 = _display displayCtrl BTN_5;
private _btn6 = _display displayCtrl BTN_6;
private _btn7 = _display displayCtrl BTN_7;
private _btn8 = _display displayCtrl BTN_8;

// Das aktuelle Ziel setzen
life_pInact_curTarget = _curTarget;

// Mindestrang für Beschlagnahmungen abrufen
private _seizeRank = LIFE_SETTINGS(getNumber,"seize_minimum_rank");

// Wenn der Spieler jemanden eskortiert, bestimmte Buttons ausblenden
if (player getVariable ["isEscorting",false]) then {
    {
        _x ctrlShow false;
    } count [_btn1,_btn2,_btn3,_btn5,_btn6,_btn7,_btn8];
}

// Unrestrain Button konfigurieren
_btn1 ctrlSetText localize "STR_pInAct_Unrestrain";
_btn1 buttonSetAction "[life_pInact_curTarget] call life_fnc_unrestrain; closeDialog 0;";

// Lizenzen überprüfen Button konfigurieren
_btn2 ctrlSetText localize "STR_pInAct_checkLicenses";
_btn2 buttonSetAction "[player] remoteExecCall [""life_fnc_licenseCheck"",life_pInact_curTarget]; closeDialog 0;";

// Durchsuchen Button konfigurieren
_btn3 ctrlSetText localize "STR_pInAct_SearchPlayer";
_btn3 buttonSetAction "[life_pInact_curTarget] spawn life_fnc_searchAction; closeDialog 0;";

// Eskortieren/Abbrechen Eskortieren Button konfigurieren
if (player getVariable ["isEscorting",false]) then {
    _btn4 ctrlSetText localize "STR_pInAct_StopEscort";
    _btn4 buttonSetAction "[] call life_fnc_stopEscorting; closeDialog 0;";
} else {
    _btn4 ctrlSetText localize "STR_pInAct_Escort";
    _btn4 buttonSetAction "[life_pInact_curTarget] call life_fnc_escortAction; closeDialog 0;";
}

// Bußgeld Button konfigurieren
_btn5 ctrlSetText localize "STR_pInAct_TicketBtn";
_btn5 buttonSetAction "[life_pInact_curTarget] call life_fnc_ticketAction;";

// Verhaften Button konfigurieren
_btn6 ctrlSetText localize "STR_pInAct_Arrest";
_btn6 buttonSetAction "[life_pInact_curTarget] call life_fnc_arrestAction; closeDialog 0;";
_btn6 ctrlEnable false;

// Ins Auto setzen Button konfigurieren
_btn7 ctrlSetText localize "STR_pInAct_PutInCar";
_btn7 buttonSetAction "[life_pInact_curTarget] call life_fnc_putInCar; closeDialog 0;";

// Beschlagnahme Button konfigurieren
_btn8 ctrlSetText localize "STR_pInAct_Seize";
_btn8 buttonSetAction "[life_pInact_curTarget] spawn life_fnc_seizePlayerAction; closeDialog 0;";

// Button deaktivieren, wenn Rang zu niedrig ist
if (FETCH_CONST(life_coplevel) < _seizeRank) then {
    _btn8 ctrlEnable false;
}

// Überprüfen, ob der Spieler in der Nähe eines Gefängnisses ist, um den Verhaften Button zu aktivieren
{
    if (player distance (getMarkerPos _x) < 30) exitWith {
        _btn6 ctrlEnable true;
    };
    true
} count LIFE_SETTINGS(getArray,"sendtoJail_locations");
