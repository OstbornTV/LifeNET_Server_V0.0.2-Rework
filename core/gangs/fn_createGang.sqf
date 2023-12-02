#include "..\..\script_macros.hpp"
/*
    File: fn_createGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Ruft das Menü auf und erstellt die Gang mit dem Namen, den der Benutzer eingibt.
*/
private ["_gangName", "_length", "_badChar", "_chrByte", "_allowed"];
disableSerialization;

// Holen Sie sich den eingegebenen Gangnamen aus dem Steuerelement
_gangName = ctrlText (CONTROL(2520,2522));

// Überprüfen Sie, ob der Gangname länger als 32 Zeichen ist
_length = count (toArray(_gangName));
if (_length > 32) exitWith {hint localize "STR_GNOTF_Over32"};

// Überprüfen Sie, ob der Gangname unerlaubte Zeichen enthält
_badChar = false;
_chrByte = toArray (_gangName);
_allowed = toArray("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ");
{if (!(_x in _allowed)) exitWith {_badChar = true;};} forEach _chrByte;
if (_badChar) exitWith {hint localize "STR_GNOTF_IncorrectChar"};

// Überprüfen Sie, ob der Spieler genügend Geld hat, um die Gang zu erstellen
if (BANK < (LIFE_SETTINGS(getNumber,"gang_price"))) exitWith {
    hint format [localize "STR_GNOTF_NotEnoughMoney",[((LIFE_SETTINGS(getNumber,"gang_price")) - BANK)] call life_fnc_numberText];
};

// Überprüfen Sie, ob Headless Client aktiv ist und rufen Sie die entsprechende Funktion auf
if (life_HC_isActive) then {
    [player,getPlayerUID player,_gangName] remoteExec ["HC_fnc_insertGang",HC_Life];
} else {
    [player,getPlayerUID player,_gangName] remoteExec ["TON_fnc_insertGang",RSERV];
}

// Erweitertes Protokoll für die Serverprotokollierung erstellen, wenn dies aktiviert ist
if (LIFE_SETTINGS(getNumber,"player_advancedLog") isEqualTo 1) then {
    if (LIFE_SETTINGS(getNumber,"battlEye_friendlyLogging") isEqualTo 1) then {
        advanced_log = format [localize "STR_DL_AL_createdGang_BEF",_gangName,(LIFE_SETTINGS(getNumber,"gang_price"))];
    } else {
        advanced_log = format [localize "STR_DL_AL_createdGang",profileName,(getPlayerUID player),_gangName,(LIFE_SETTINGS(getNumber,"gang_price"))];
    };
    publicVariableServer "advanced_log";
}

// Zeige einen Hinweis an und schließe das Dialogfeld
hint localize "STR_NOTF_SendingData";
closeDialog 0;
life_action_gangInUse = true;

