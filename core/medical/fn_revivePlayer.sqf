#include "..\..\script_macros.hpp"
/*
    Datei: fn_revivePlayer.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Startet den Wiederbelebungsprozess des Spielers.
*/
if !(params[["_target", objNull, [objNull]]]) exitWith {};

// Holen Sie sich die Revive-Kosten aus den Einstellungen
private _reviveCost = LIFE_SETTINGS(getNumber, "revive_fee");
// Überprüfen, ob das Ziel wiederbelebt werden kann
private _revivable = _target getVariable ["Revive", false];

if (_revivable) exitWith {};
// Überprüfen, ob das Ziel bereits von einem anderen Spieler wiederbelebt wird
if (_target getVariable ["Reviving", objNull] isEqualTo player) exitWith {hint localize "STR_Medic_AlreadyReviving";};
// Überprüfen, ob der Spieler in ausreichender Entfernung zum Ziel ist
if (player distance _target > 5) exitWith {};

// Variablen initialisieren
private _targetName = _target getVariable ["name", "Unknown"];
private _title = format [localize "STR_Medic_Progress", _targetName];
life_action_inUse = true; // Kontrollen sperren

_target setVariable ["Reviving", player, true];
disableSerialization;
"progressBar" cutRsc ["life_progress", "PLAIN"];
private _ui = uiNamespace getVariable ["life_progress", displayNull];
private _progressBar = _ui displayCtrl 38201;
private _titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
private _cP = 0.01;

private _badDistance = false;

// Fortschrittsbalken aktualisieren
for "_i" from 0 to 1 step 0 do {
    // Animation synchronisieren und abspielen
    if !(animationState player isEqualTo "ainvpknlmstpsnonwnondnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1"] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    uiSleep .15;
    _cP = _cP + .01;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _title];
    if (_cP >= 1 || {!alive player}) exitWith {};
    // Überprüfen, ob der Spieler getazed, geknockt oder unterbrochen wurde
    if (life_istazed || {life_isknocked} || {life_interrupted}) exitWith {};
    // Überprüfen, ob der Spieler gefesselt ist oder das Ziel bereits wiederbelebt wurde
    if (player getVariable ["restrained", false] || {_target getVariable ["Revive", false]}) exitWith {};
    // Überprüfen, ob das Ziel von einem anderen Spieler wiederbelebt wird
    if !(_target getVariable ["Reviving", objNull] isEqualTo player) exitWith {};
};

// UI ausblenden und verschiedene Zustände überprüfen
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";

if !(_target getVariable ["Reviving", objNull] isEqualTo player) exitWith {hint localize "STR_Medic_AlreadyReviving"; life_action_inUse = false;};
_target setVariable ["Reviving", nil, true];

if (!alive player || {life_istazed} || {life_isknocked}) exitWith {life_action_inUse = false;};
if (_target getVariable ["Revive", false]) exitWith {hint localize "STR_Medic_RevivedRespawned"; life_action_inUse = false;};
if (player getVariable ["restrained", false]) exitWith {life_action_inUse = false;};
if (_badDistance) exitWith {titleText[localize "STR_Medic_TooFar","PLAIN"]; life_action_inUse = false;};
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_action_inUse = false;};

life_action_inUse = false;
_target setVariable ["Revive", true, true];
[profileName] remoteExecCall ["life_fnc_revived", _target];

// Wenn der Spieler unabhängig ist, bezahlt er die Wiederbelebungskosten
if (playerSide isEqualTo independent) then {
    titleText[format [localize "STR_Medic_RevivePayReceive", _targetName,[_reviveCost] call life_fnc_numberText], "PLAIN"];
    BANK = BANK + _reviveCost;
    [1] call SOCK_fnc_updatePartial;
};

sleep .6;
player reveal _target;
