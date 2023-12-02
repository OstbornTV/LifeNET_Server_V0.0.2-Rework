#include "..\..\script_macros.hpp"
/*
    File: fn_postNewsBroadcast.sqf
    Author: Jesse "tkcjesse" Schultz

    Description:
    Handles actions after the broadcast button is clicked.
*/

// Verbesserte Variablenbenennung
private ["_headerCtrlText", "_messageCtrlText", "_length", "_badCharacter", "_allowedChars", "_allowedLength"];
disableSerialization;

// Verwendet aussagekräftigere Variablennamen
_headerCtrlText = ctrlText (CONTROL(100100, 100101));
_messageCtrlText = ctrlText (CONTROL(100100, 100102));
_length = count (toArray (_headerCtrlText));
_allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ";
_allowedLength = LIFE_SETTINGS(getNumber, "news_broadcast_header_length");
_badCharacter = false;

// Überarbeitete String-Überprüfungsfunktion
private ["_isValidCharacter"];
_isValidCharacter = {!isNil "_x" && { _allowedChars find _x != -1 };};

if (_length > _allowedLength) exitWith { hint format [localize "STR_News_HeaderLength", _allowedLength]; };

// Optimiert die Überprüfung auf erlaubte Zeichen
if (!all {_isValidCharacter _x} toArray _headerCtrlText) exitWith { hint localize "STR_News_UnsupportedCharacter" };

[_headerCtrlText, _messageCtrlText, profileName] remoteExec ['life_fnc_AAN', -2];

CASH = CASH - LIFE_SETTINGS(getNumber, "news_broadcast_cost");
[0] call SOCK_fnc_updatePartial;
life_broadcastTimer = time;
publicVariable "life_broadcastTimer";
