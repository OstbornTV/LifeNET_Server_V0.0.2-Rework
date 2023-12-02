#include "..\..\script_macros.hpp"
/*
    File: fn_defuseKit.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Defuses blasting charges for the cops?
*/

// Parametrisiere den Tresor und die UI-Elemente
private ["_vault", "_ui", "_title", "_progressBar", "_cP", "_titleText"];
_vault = param [0, objNull, [objNull]];

// Überprüfe, ob der Tresor existiert und vom richtigen Typ ist
if (isNull _vault) exitWith {};
if (typeOf _vault != "Land_CargoBox_V1_F") exitWith { hint localize "STR_ISTR_defuseKit_NotNear"; };
if (!(_vault getVariable ["chargeplaced", false])) exitWith { hint localize "STR_ISTR_Defuse_Nothing"; };

// Setze die Flagge für die laufende Aktion
life_action_inUse = true;

// Setup Fortschrittsbalken
disableSerialization;
_title = localize "STR_ISTR_Defuse_Process";
"progressBar" cutRsc ["life_progress", "PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;

// Iteriere durch den Fortschrittsbalken
for "_i" from 0 to 1 step 0 do {
    // Synchronisiere die Animation des Spielers, wenn nicht bereits geschehen
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    // Aktualisiere den Fortschrittsbalken und die Textanzeige
    uiSleep 0.26;
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress", "PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    _cP = _cP + 0.0035;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _title];

    // Beende die Schleife, wenn der Fortschrittsbalken voll ist oder der Spieler nicht mehr lebt
    if (_cP >= 1 || !alive player) exitWith {};
    if (life_interrupted) exitWith {};
};

// Beende den Fortschrittsbalken und überprüfe verschiedene Zustände
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";
if (!alive player) exitWith { life_action_inUse = false; };
if (life_interrupted) exitWith { life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_action_inUse = false; };

// Setze die Flagge für die abgeschlossene Aktion zurück
life_action_inUse = false;

// Aktualisiere die Variable im Tresor und sende eine Erfolgsmeldung an die West-Fraktion
_vault setVariable ["chargeplaced", false, true];
[0, localize "STR_ISTR_Defuse_Success"] remoteExecCall ["life_fnc_broadcast", west];
