#include "..\..\script_macros.hpp"
/*
    Datei: fn_onPlayerKilled.sqf
    Autor: Bryan "Tonic" Boardwine
    Beschreibung:
    Wenn der Spieler stirbt, werden verschiedene Informationen über den Spieler gesammelt,
    und das Todesdialog-/Kameraverhalten wird aufgerufen.
*/
params [
    ["_unit", objNull, [objNull]],
    ["_killer", objNull, [objNull]]
];
disableSerialization;

// Fahrzeugfreigabe und Versetzung des Spielers aus dem Fahrzeug
if !((vehicle _unit) isEqualTo _unit) then {
    UnAssignVehicle _unit;
    _unit action ["getOut", vehicle _unit];
    _unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
};

// Setze einige Variablen
_unit setVariable ["Revive", true, true];
_unit setVariable ["name", profileName, true]; // Setze meinen Namen, damit sie meinen Namen sagen können.
_unit setVariable ["restrained", false, true];
_unit setVariable ["Escorting", false, true];
_unit setVariable ["transporting", false, true];
_unit setVariable ["playerSurrender", false, true];
_unit setVariable ["steam64id", (getPlayerUID player), true]; // Setze die UID.

// Schließe das Escape-Dialogfeld
if (dialog) then {
    closeDialog 0;
};

// Richte unsere Kameraperspektive ein
life_deathCamera = "CAMERA" camCreate (getPosATL _unit);
showCinemaBorder true;
life_deathCamera cameraEffect ["Internal", "Back"];
createDialog "DeathScreen";
life_deathCamera camSetTarget _unit;
life_deathCamera camSetRelPos [0, 3.5, 4.5];
life_deathCamera camSetFOV .5;
life_deathCamera camSetFocus [50, 0];
life_deathCamera camCommit 0;

(findDisplay 7300) displaySetEventHandler ["KeyDown", "if ((_this select 1) isEqualTo 1) then {true}"]; //Blockiert das ESC-Menü

// Erstelle einen Thread für etwas?
_unit spawn {
    private ["_maxTime", "_RespawnBtn", "_Timer"];
    disableSerialization;
    _RespawnBtn = ((findDisplay 7300) displayCtrl 7302);
    _Timer = ((findDisplay 7300) displayCtrl 7301);
    if (LIFE_SETTINGS(getNumber, "respawn_timer") < 5) then {
        _maxTime = time + 5;
    } else {
        _maxTime = time + LIFE_SETTINGS(getNumber, "respawn_timer");
    };
    _RespawnBtn ctrlEnable false;
    waitUntil {
        _Timer ctrlSetText format [localize "STR_Medic_Respawn", [(_maxTime - time), "MM:SS"] call BIS_fnc_secondsToString];
        round(_maxTime - time) <= 0 || isNull _this
    };
    _RespawnBtn ctrlEnable true;
    _Timer ctrlSetText localize "STR_Medic_Respawn_2";
};

_unit spawn {
    disableSerialization;
    private _requestBtn = ((findDisplay 7300) displayCtrl 7303);
    _requestBtn ctrlEnable false;
    private _requestTime = time + 5;
    waitUntil {round(_requestTime - time) <= 0 || isNull _this};
    _requestBtn ctrlEnable true;
};

[] spawn life_fnc_deathScreen;

// Erstelle einen Thread, um dem toten Körper mit relativ präziser Ansicht zu folgen.
[_unit] spawn {
    private _unit = _this select 0;
    waitUntil {
        life_deathCamera camSetTarget _unit;
        life_deathCamera camSetRelPos [0, 3.5, 4.5];
        life_deathCamera camCommit 0;
        speed _unit isEqualTo 0
    };
};

// Mache den Killer gesucht
if (!isNull _killer && {!(_killer isEqualTo _unit)} && {!(side _killer isEqualTo west)} && {alive _killer}) then {
    private _wantedType = (vehicle _killer isKindOf "LandVehicle") ? "187V" : "187";
    private _wantedFunction = (life_HC_isActive) ? "HC_fnc_wantedAdd" : "life_fnc_wantedAdd";

    [_killer, _killer getVariable ["realname", name _killer], _wantedType] remoteExecCall [_wantedFunction, (life_HC_isActive) then {HC_Life} else {RSERV}];

    // Entferne die Fahrzeuglizenz automatisch, wenn gewünscht
    if (!local _killer) then {
        private _licenseType = (vehicle _killer isKindOf "LandVehicle") ? 2 : 3;
        [_licenseType] remoteExecCall ["life_fnc_removeLicenses", _killer];
    };
};

// Speichere die Ausrüstung des Spielers vor dem Tod
life_save_gear = getUnitLoadout player;

// Falls gewünscht, entferne die Waffen des Spielers nach dem Tod
if (LIFE_SETTINGS(getNumber, "drop_weapons_onDeath") isEqualTo 0) then {
    _unit removeWeapon (primaryWeapon _unit);
    _unit removeWeapon (handgunWeapon _unit);
    _unit removeWeapon (secondaryWeapon _unit);
};

// Aktionen bei Tod durch einen Polizisten
if (side _killer isEqualTo west && !(playerSide isEqualTo west)) then {
    life_copRecieve = _killer;
    // Habe ich das Federal Reserve überfallen?
    if (!life_use_atm && {CASH > 0}) then {
        [format [localize "STR_Cop_RobberDead", [CASH] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast", RCLIENT];
    };
};

// Falls gewünscht, entferne den Fahndungsstatus nach dem Tod
if (!isNull _killer && {!(_killer isEqualTo _unit)}) then {
    life_removeWanted = true;
};

// Lasse Gegenstände fallen
//[_unit] call life_fnc_dropItems;

// Zurücksetzen von Variablen und HUD-Updates
life_action_inUse = false;
life_is_alive = false;

[] call life_fnc_hudUpdate; // Aktualisiere das HUD.
[player, life_settings_enableSidechannel, playerSide] remoteExecCall ["TON_fnc_manageSC", RSERV];

[0] call SOCK_fnc_updatePartial;
[3] call SOCK_fnc_updatePartial;
if (playerSide isEqualTo civilian) then {
    [4] call SOCK_fnc_updatePartial;
};
