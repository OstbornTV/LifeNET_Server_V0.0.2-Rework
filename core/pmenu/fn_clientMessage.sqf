#include "..\..\script_macros.hpp"
/*
    Datei: fn_clientMessage.sqf
    Autor: Bryan "Tonic" Boardwine
    Beschreibung: Zeigt eine empfangene Nachricht an
*/
params [
    ["_msg", "", [""]],            // Nachrichtentext
    ["_from", "", [""]],           // Absender
    ["_type", "", [""]],           // Nachrichtentyp (Cop, Med, Admin, AdminAll, AdminToPlayer)
    ["_loc", "Unknown", [""]]      // Ort (standardmäßig "Unknown")
];

// Wenn Absender oder Nachricht leer sind, wird abgebrochen
if (_from isEqualTo "" || {_msg isEqualTo ""}) exitWith {};
private _message = "";

// Je nach Nachrichtentyp werden unterschiedliche Aktionen durchgeführt
switch (toLower _type) do {
    case "cop" : {
        if !(playerSide isEqualTo west) exitWith {};
        _message = format ["--- 110 DISPATCH VON %1: %2",_from,_msg];

        // Benachrichtigung für Polizei
        hint parseText format ["<t color='#316dff'><t size='2'><t align='center'>Neue Meldung<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Alle Beamte<br/><t color='#33CC33'>Von: <t color='#ffffff'>%1<br/><t color='#33CC33'>Koordinaten: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%3",_from,_loc,_msg];

        // Benachrichtigung im Spiel
        ["PoliceDispatch",[format ["Neuer Polizeibericht von: %1",_from]]] call bis_fnc_showNotification;
    };

    case "med": {
        if !(playerSide isEqualTo independent) exitWith {};

        _message = format ["!!! 112 ANFRAGE: %1",_msg];

        // Benachrichtigung für Sanitäter
        hint parseText format ["<t color='#FFCC00'><t size='2'><t align='center'>112 Anfrage<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Euch<br/><t color='#33CC33'>Von: <t color='#ffffff'>%1<br/><t color='#33CC33'>Koordinaten: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%3",_from,_loc,_msg];

        // Benachrichtigung im Spiel
        ["TextMessage",[format ["112-Anfrage von %1",_from]]] call bis_fnc_showNotification;
    };

    case "admin" : {
        // Nur wenn Spieler Admin-Rechte haben
        if ((call life_adminlevel) < 1) exitWith {};
        _message = format ["!!! ADMIN ANFRAGE VON %1: %2",_from,_msg];

        // Benachrichtigung für Admins
        hint parseText format ["<t color='#ffcefe'><t size='2'><t align='center'>Admin-Anfrage<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Admins<br/><t color='#33CC33'>Von: <t color='#ffffff'>%1<br/><t color='#33CC33'>Koordinaten: <t color='#ffffff'>%2<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%3",_from,_loc,_msg];

        // Benachrichtigung im Spiel
        ["AdminDispatch",[format ["%1 hat einen Admin angefordert!",_from]]] call bis_fnc_showNotification;
    };

    case "adminall" : {
        _message = format ["!!! ADMIN NACHRICHT: %1",_msg];
        _admin = format ["Gesendet von Admin: %1", _from];

        // Benachrichtigung für alle Spieler
        hint parseText format ["<t color='#FF0000'><t size='2'><t align='center'>Admin-Nachricht<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Dich<br/><t color='#33CC33'>Von: <t color='#ffffff'>Ein Admin<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%1",_msg];

        // Benachrichtigung im Spiel
        ["AdminMessage",["Du hast eine Nachricht von einem Admin erhalten!"]] call bis_fnc_showNotification;
        // Wenn Admin-Level größer als 0, dann zusätzlich im globalen Chat ausgeben
        if ((call life_adminlevel) > 0) then {systemChat _admin;};
    };

    case "admintoplayer": {
        _message = format ["!!!ADMIN NACHRICHT: %1",_msg];

        // Benachrichtigung für alle Spieler
        hint parseText format ["<t color='#FF0000'><t size='2'><t align='center'>Admin-Nachricht<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Alle Spieler<br/><t color='#33CC33'>Von: <t color='#ffffff'>Die Admins<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%1",_msg];

        // Benachrichtigung im Spiel
        ["AdminMessage",["Du hast eine Nachricht von einem Admin erhalten!"]] call bis_fnc_showNotification;
        // Wenn Admin-Level größer als 0, dann zusätzlich im globalen Chat ausgeben
        if ((call life_adminlevel) > 0) then {
            private _admin = format ["Gesendet von Admin: %1", _from];
            systemChat _admin;
        };
    };

    default {
        _message = format [">>>NACHRICHT VON %1: %2",_from,_msg];

        // Benachrichtigung für private Nachrichten
        hint parseText format ["<t color='#FFCC00'><t size='2'><t align='center'>Neue Nachricht<br/><br/><t color='#33CC33'><t align='left'><t size='1'>An: <t color='#ffffff'>Dich<br/><t color='#33CC33'>Von: <t color='#ffffff'>%1<br/><br/><t color='#33CC33'>Nachricht:<br/><t color='#ffffff'>%2",_from,_msg];

        // Benachrichtigung im Spiel
        ["TextMessage",[format ["Du hast eine neue private Nachricht von %1 erhalten",_from]]] call bis_fnc_showNotification;
    };
};

// Nachricht auch im globalen Chat ausgeben
systemChat _message;
