#include "..\..\script_macros.hpp"
/*
    File: fn_safeFix.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Funktionalität für Polizisten, um den Safe zu schließen (zu sperren)
*/

// Lokale Variable für den Safe deklarieren
private "_vault";
_vault = _this select 0;

// Überprüfen, ob der Safe geöffnet ist
if (!(_vault getVariable ["safe_open", false])) exitWith { hint localize "STR_Cop_VaultLocked" };

// Variable, die anzeigt, dass eine Aktion in Benutzung ist, setzen
life_action_inUse = true;

// Fortschrittsbalken und UI-Elemente einrichten
disableSerialization;
_title = localize "STR_Cop_RepairVault";
"progressBar" cutRsc ["life_progress", "PLAIN"];
_ui = uiNamespace getVariable "life_progress";
_progressBar = _ui displayCtrl 38201;
_titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...", "%", _title];
_progressBar progressSetPosition 0.01;
_cP = 0.01;

// Fortschrittsanimation durchführen
for "_i" from 0 to 1 step 0 do {
    // Animation für den Spieler setzen
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    uiSleep 0.26;

    // UI aktualisieren
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress", "PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };
    
    // Fortschritt erhöhen
    _cP = _cP + .012;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _title];

    // Überprüfen, ob der Fortschritt abgeschlossen ist oder der Spieler nicht mehr lebt
    if (_cP >= 1 || !alive player) exitWith {};
    if (life_interrupted) exitWith {};
};

// UI schließen und verschiedene Zustände überprüfen
"progressBar" cutText ["", "PLAIN"];
player playActionNow "stop";
if (!alive player) exitWith { life_action_inUse = false; };
if (life_interrupted) exitWith { life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_action_inUse = false; };

// Aktion beenden und Safe schließen
life_action_inUse = false;
_vault setVariable ["safe_open", false, true];
hint localize "STR_Cop_VaultRepaired";
