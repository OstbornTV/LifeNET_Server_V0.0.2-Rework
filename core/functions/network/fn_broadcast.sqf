#include "..\..\script_macros.hpp"
/*
    File: fn_broadcast.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Broadcast system used in the life mission for multi-notification purposes.
*/

params [
    ["_type", 0, [0, []]],  // Typ der Benachrichtigung (0: systemChat, 1: hint, 2: titleText, 3: hint mit parseText)
    ["_message", "", [""]], // Die Nachricht, die gesendet werden soll
    ["_localize", false, [false]], // Ob die Nachricht lokalisiert werden soll
    ["_arr", [], [[]]] // Array von Werten, die in die lokalisierte Nachricht eingefügt werden sollen
];

// Beenden Sie das Skript, wenn die Nachricht leer ist
if (_message isEqualTo "") exitWith {};

// Überprüfen Sie, ob die Nachricht lokalisiert werden soll
if (_localize) exitWith {
    private _msg = switch (count _arr) do {
        case 0: {localize _message;};
        case 1: {format [localize _message, _arr select 0];};
        case 2: {format [localize _message, _arr select 0, _arr select 1];};
        case 3: {format [localize _message, _arr select 0, _arr select 1, _arr select 2];};
        case 4: {format [localize _message, _arr select 0, _arr select 1, _arr select 2, _arr select 3];};
    };

    // Überprüfen Sie den Typ der Benachrichtigung und senden Sie die lokalisierte Nachricht
    if (_type isEqualType []) then {
        {
            switch (_x) do {
                case 0: {systemChat _msg;}; // systemChat
                case 1: {hint _msg;}; // hint
                case 2: {titleText[_msg,"PLAIN"];}; // titleText
            };
            true
        } count _type;
    } else {
        switch (_type) do {
            case 0: {systemChat _msg;};
            case 1: {hint _msg;};
            case 2: {titleText[_msg,"PLAIN"];};
        };
    };
};

// Überprüfen Sie den Typ der Benachrichtigung und senden Sie die nicht lokalisierte Nachricht
if (_type isEqualType []) then {
    {
        switch (_x) do {
            case 0: {systemChat _message}; // systemChat
            case 1: {hint format ["%1", _message]}; // hint
            case 2: {titleText[format ["%1",_message],"PLAIN"];}; // titleText
            case 3: {hint parseText format ["%1", _message]}; // hint mit parseText
        };
        true
    } count _type;
} else {
    switch (_type) do {
        case 0: {systemChat _message};
        case 1: {hint format ["%1", _message]};
        case 2: {titleText[format ["%1",_message],"PLAIN"];};
        case 3: {hint parseText format ["%1", _message]};
    };
};