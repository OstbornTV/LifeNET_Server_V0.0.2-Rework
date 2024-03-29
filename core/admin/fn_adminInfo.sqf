#include "..\..\script_macros.hpp"
/*
    File: fn_adminInfo.sqf
    Author: Bryan "Tonic" Boardwine
    Description: Gibt empfangene Informationen im Admin-Menü aus.
*/

// Parameterdefinition
params [
    ["_bank", 0, [0]],
    ["_cash", 0, [0]],
    ["_owner", -1, [0]],
    ["_unit", objNull, [objNull]],
    ["_steamName", "", [""]],
    ["_uid", "", [""]],
    ["_side", sideUnknown, [civilian]]
];

// Deaktiviert die Serialisierung
disableSerialization;

// Ermittelt die Anzeigeinformationen für Primärwaffe, Sekundärwaffe, Weste, Uniform und Rucksack
private _prim = if !(primaryWeapon _unit isEqualTo "") then {FETCH_CONFIG2(getText,"CfgWeapons",primaryWeapon _unit,"displayName")} else {"None"};
private _sec = if !(handgunWeapon _unit isEqualTo "") then {FETCH_CONFIG2(getText,"CfgWeapons",handgunWeapon _unit,"displayName")} else {"None"};
private _vest = if !(vest _unit isEqualTo "") then {FETCH_CONFIG2(getText,"CfgWeapons",vest _unit,"displayName")} else {"None"};
private _uni = if !(uniform _unit isEqualTo "") then {FETCH_CONFIG2(getText,"CfgWeapons",uniform _unit,"displayName")} else {"None"};
private _bp = if !(backpack _unit isEqualTo "") then {FETCH_CONFIG2(getText,"CfgVehicles",backpack _unit,"displayName")} else {"None"};

// Initialisiert leere Arrays für Anhänge und Sekundärwaffen
private _attach = [];
private _secondary = [];

// Ermittelt Anhänge für Primärwaffe
if !(primaryWeapon _unit isEqualTo "") then {
    {
        if !(_x isEqualTo "") then {
            _attach pushBack (FETCH_CONFIG2(getText,"CfgWeapons",_x,"displayName"));
        };
        true
    } count (primaryWeaponItems _unit);
};

// Ermittelt Anhänge für Sekundärwaffe
if !(handgunItems _unit isEqualTo "") then {
    {
        if !(_x isEqualTo "") then {
            _secondary pushBack (FETCH_CONFIG2(getText,"CfgWeapons",_x,"displayName"));
        };
        true
    } count (handgunItems _unit);
};

// Prüft, ob Steam-Name vorhanden ist
if !(_steamName isEqualType "") then {
    _steamName = "Not a Steam User!";
};

// Setzt den strukturierten Text des Admin-Menüs
CONTROL(2900,2903) ctrlSetStructuredText parseText format ["<t size='.7'>Name: %1<br/>Steam Name: %10<br/>Player UID: %11<br/>Player Side: %12<br/>Bank: %2<br/>Money: %3<br/>Uniform: %4<br/>Vest: %5<br/>Backpack: %6<br/>Primary: %7<br/>Handgun: %8<br/><t align='center'>Primary Attachments</t><br/>%9<br/><t align='center'>Secondary Attachments</t><br/>%13<br/></t>",
_unit getVariable ["realname",name _unit],[_bank] call life_fnc_numberText,[_cash] call life_fnc_numberText, _uni,_vest,_bp,_prim,_sec,_attach,_steamName,_uid,_side,_secondary];
