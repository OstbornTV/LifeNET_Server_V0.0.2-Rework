#include "..\..\script_macros.hpp"
/*
    File: fn_lockpick.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Main functionality for lock-picking.
*/

// Überprüfen Sie, ob das Lockpicking erlaubt ist
if !(life_canLockpick) exitWith {};

// Holen Sie sich das Zielobjekt, auf das der Cursor zeigt
private _curTarget = cursorObject;

// Setzen Sie die Unterbrechung zurück
life_interrupted = false;

// Überprüfen Sie verschiedene Bedingungen, um festzustellen, ob die Aktion fortgesetzt werden kann
if (life_action_inUse) exitWith {};
if (isNull _curTarget) exitWith { /* Ungültiger Typ */ };
private _distance = ((boundingBox _curTarget select 1) select 0) + 2;
if (player distance _curTarget > _distance) exitWith { /* Zu weit entfernt */ };

// Überprüfen Sie, ob das Ziel ein Fahrzeug ist und ob es bereits dem Spieler gehört
private _isVehicle = if ((_curTarget isKindOf "LandVehicle") || (_curTarget isKindOf "Ship") || (_curTarget isKindOf "Air")) then {true} else {false};
if (_isVehicle && _curTarget in life_vehicles) exitWith {hint localize "STR_ISTR_Lock_AlreadyHave"};

// Weitere Fehlerprüfungen
if (!_isVehicle && !isPlayer _curTarget) exitWith {};
if (!_isVehicle && !(_curTarget getVariable ["restrained",false])) exitWith {};
if (_curTarget getVariable "NPC") exitWith {hint localize "STR_NPC_Protected"};

// Festlegen des Titels basierend auf dem Zieltyp
private _title = format [localize "STR_ISTR_Lock_Process", if (!_isVehicle) then {"Handcuffs"} else {getText(configFile >> "CfgVehicles" >> (typeOf _curTarget) >> "displayName")}];

// Aktion in Benutzung setzen, um parallele Aktionen zu verhindern
life_action_inUse = true;

// Fortschrittsbalken initialisieren
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progressBar = _ui displayCtrl 38201;
private _titleText = _ui displayCtrl 38202;
_titleText ctrlSetText format ["%2 (1%1)...","%",_title];
_progressBar progressSetPosition 0.01;
private _cP = 0.01;

// Fortschrittsbalken-Schleife
for "_i" from 0 to 1 step 0 do {
    // Synchronisieren Sie die Animation des Spielers
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExecCall ["life_fnc_animSync",RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };

    // Warten Sie kurz zwischen den Fortschrittsschritten
    uiSleep 0.26;

    // Überprüfen Sie die UI-Elemente
    if (isNull _ui) then {
        "progressBar" cutRsc ["life_progress","PLAIN"];
        _ui = uiNamespace getVariable "life_progress";
        _progressBar = _ui displayCtrl 38201;
        _titleText = _ui displayCtrl 38202;
    };

    // Aktualisieren Sie den Fortschrittsbalken
    _cP = _cP + 0.01;
    _progressBar progressSetPosition _cP;
    _titleText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];

    // Überprüfen Sie die Abbruchbedingungen
    if (_cP >= 1 || !alive player) exitWith {};
    if (life_istazed) exitWith { /* Betäubt */ };
    if (life_isknocked) exitWith { /* Bewusstlos */ };
    if (life_interrupted) exitWith {};
    if (player getVariable ["restrained",false]) exitWith { /* Eingeschränkt */ };
    if (player distance _curTarget > _distance) exitWith {_badDistance = true;};
};

// Schließen Sie die Fortschrittsanzeige und überprüfen Sie verschiedene Zustände
"progressBar" cutText ["","PLAIN"];
player playActionNow "stop";

if (!alive player || life_istazed || life_isknocked) exitWith {life_action_inUse = false;};
if (player getVariable ["restrained",false]) exitWith {life_action_inUse = false;};
if (!isNil "_badDistance") exitWith {titleText[localize "STR_ISTR_Lock_TooFar","PLAIN"]; life_action_inUse = false;};
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_action_inUse = false;};
if (!([false,"lockpick",1] call life_fnc_handleInv)) exitWith {life_action_inUse = false;};

// Aktion als nicht in Benutzung setzen
life_action_inUse = false;

// Verarbeiten Sie das Ergebnis des Lockpick-Vorgangs basierend auf dem Zieltyp
if (!_isVehicle) then {
    _curTarget setVariable ["restrained",false,true];
    _curTarget setVariable ["Escorting",false,true];
    _curTarget setVariable ["transporting",false,true];
} else {
    private _dice = random(100);

    if (_dice < 30) then {
        // Erfolgreiches Lockpick
        titleText[localize "STR_ISTR_Lock_Success","PLAIN"];
        life_vehicles pushBack _curTarget;

        // Fügen Sie den Spieler der Wanted-Liste hinzu
        if (life_HC_isActive) then {
            [getPlayerUID player,profileName,"487"] remoteExecCall ["HC_fnc_wantedAdd",HC_Life];
        } else {
            [getPlayerUID player,profileName,"487"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };
    } else {
        // Fehlgeschlagenes Lockpick
        if (life_HC_isActive) then {
            [getPlayerUID player,profileName,"215"] remoteExecCall ["HC_fnc_wantedAdd",HC_Life];
        } else {
            [getPlayerUID player,profileName,"215"] remoteExecCall ["life_fnc_wantedAdd",RSERV];
        };

        // Benachrichtigung über das Fehlschlagen des Lockpick-Vorgangs
        [0,"STR_ISTR_Lock_FailedNOTF",true,[profileName]] remoteExecCall ["life_fnc_broadcast",west];
        titleText[localize "STR_ISTR_Lock_Failed","PLAIN"];
    };
};
