#include "..\..\script_macros.hpp"
/*
    File: fn_AAN.sqf
    Author: Karel Moricky
    Modified: Jesse "tkcjesse" Schultz

    Description:
    Displays a news broadcast on the screen.

    Parameter(s):
    _this select 0: STRUCTURED TEXT: Header text
    _this select 1: STRUCTURED TEXT: Bottom text (moving)
    _this select 2: PROFILENAME: Below Header text
*/

// Extrahiere die Parameter
private ["_header", "_line", "_sender", "_display", "_textHeader", "_textLine", "_textLinePos", "_textClock"];
_header = _this select 0;
_line = _this select 1;
_sender = _this select 2;

// Deaktiviere die Serialisierung
disableSerialization;

// Exit, wenn die News-Benachrichtigungen deaktiviert sind oder der Stream-freundliche UI-Modus aktiviert ist
if (!life_settings_enableNewsBroadcast || isStreamFriendlyUIEnabled) exitWith {};

// Erstelle das Nachrichten-Display
30 cutRsc ["rscAAN", "plain"];
_display = uiNamespace getVariable "BIS_AAN";

// Setze den Header-Text
_textHeader = _display displayCtrl 3001;
_textHeader ctrlSetStructuredText parseText format [localize "STR_News_BroadcastedBy", _header, _sender];
_textHeader ctrlCommit 0;

// Setze den Bottom-Text
_textLine = _display displayCtrl 3002;
_textLine ctrlSetStructuredText parseText format ["                         %1                         %1                         %1                         %1                         ", _line];
_textLine ctrlCommit 0;

// Setze die Position des Bottom-Texts
_textLinePos = ctrlPosition _textLine;
_textLinePos set [0, -100];
_textLine ctrlSetPosition _textLinePos;
_textLine ctrlCommit 1500;

// Setze den Uhrzeit-Text
_textClock = _display displayctrl 3003;
_textClock ctrlSetText ([daytime, "HH:MM"] call bis_fnc_timetostring);
_textClock ctrlCommit 0;

// Warte 30 Sekunden und entferne das Nachrichten-Display
sleep 30;
30 cutText ["", "plain"];
