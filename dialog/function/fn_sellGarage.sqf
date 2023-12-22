#include "..\..\script_macros.hpp"
/*
    File: fn_sellGarage.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sells a vehicle from the garage.
*/

// Lokale Variablen deklarieren
private ["_vehicle", "_vehicleLife", "_vid", "_pid", "_sellPrice", "_multiplier", "_price", "_purchasePrice"];

// Serialisierung deaktivieren
disableSerialization;

// Überprüfen, ob ein Fahrzeug ausgewählt ist
if ((lbCurSel 2802) isEqualTo -1) exitWith { hint localize "STR_Global_NoSelection"; };

// Fahrzeuginformationen abrufen
_vehicle = lbData[2802, (lbCurSel 2802)];
_vehicle = (call compile format ["%1", _vehicle]) select 0;
_vehicleLife = _vehicle;
_vid = lbValue[2802, (lbCurSel 2802)];
_pid = getPlayerUID player;

// Fehlerüberprüfungen
if (isNil "_vehicle") exitWith { hint localize "STR_Garage_Selection_Error"; };
if ((time - life_action_delay) < 1.5) exitWith { hint localize "STR_NOTF_ActionDelay"; };
if (!isClass (missionConfigFile >> "LifeCfgVehicles" >> _vehicleLife)) then {
    _vehicleLife = "Default"; // Standardklasse verwenden, wenn sie nicht existiert
    diag_log format ["%1: LifeCfgVehicles class doesn't exist", _vehicle];
};

// Fahrzeugpreis und Verkaufspreis berechnen
_price = M_CONFIG(getNumber, "LifeCfgVehicles", _vehicleLife, "price");
_multiplier = LIFE_SETTINGS(getNumber, format ["vehicle_sell_multiplier_%1", playerSide]);
_purchasePrice = _price * LIFE_SETTINGS(getNumber, format ["vehicle_purchase_multiplier_%1", playerSide]);
_sellPrice = _purchasePrice * _multiplier;

// Mindestverkaufspreis festlegen
if (!(_sellPrice isEqualType 0) || _sellPrice < 1) then {
    _sellPrice = 500;
};

// Dialog schließen und Bestätigungsdialog anzeigen
closeDialog 0;
private _action = [
    format [localize "STR_Garage_SellWarn", getText(configFile >> "CfgVehicles" >> _vehicle >> "displayName"), [_sellPrice] call life_fnc_numberText],
    localize "STR_Garage_SellWarnTitle",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Wenn Bestätigung verneint wird, die Funktion verlassen
if !(_action) exitWith {};

// Fahrzeug löschen und Meldung anzeigen
if (life_HC_isActive) then {
    [_vid, _pid, _sellPrice, player, life_garage_type] remoteExecCall ["HC_fnc_vehicleDelete", HC_Life];
} else {
    [_vid, _pid, _sellPrice, player, life_garage_type] remoteExecCall ["TON_fnc_vehicleDelete", RSERV];
};

hint format [localize "STR_Garage_SoldCar", [_sellPrice] call life_fnc_numberText];

// Geld auf Bankkonto übertragen und GUI aktualisieren
BANK = BANK + _sellPrice;
[1] call SOCK_fnc_updatePartial;

// Fortschritt im erweiterten Protokoll aufzeichnen
if (LIFE_SETTINGS(getNumber, "player_advancedLog") isEqualTo 1) then {
    private _logMessage;

    if (LIFE_SETTINGS(getNumber, "battlEye_friendlyLogging") isEqualTo 1) then {
        _logMessage = format ["STR_DL_AL_soldVehicle_BEF", _vehicleLife, [_sellPrice] call life_fnc_numberText, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
    } else {
        _logMessage = format ["STR_DL_AL_soldVehicle", profileName, (getPlayerUID player), _vehicleLife, [_sellPrice] call life_fnc_numberText, [BANK] call life_fnc_numberText, [CASH] call life_fnc_numberText];
    };

    advanced_log = _logMessage;
    publicVariableServer "advanced_log";
};

// Aktion verzögern
life_action_delay = time;
