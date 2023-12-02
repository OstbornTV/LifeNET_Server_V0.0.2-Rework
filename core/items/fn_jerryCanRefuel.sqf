#include "..\..\script_macros.hpp"
/*
    File: fn_jerryCanRefuel.sqf
    Author: Bryan "Tonic" Boardwine
    Modified: Jesse "tkcjesse" Schultz

    Description:
    Refuels the empty fuel canister at a gas pump. Based off the jerryRefuel/lockpick scripts by Tonic.
*/

// Überprüfe, ob der Spieler eine leere Benzinkanister hat
life_interrupted = false;
if (life_inv_fuelEmpty isEqualTo 0) exitWith {};

// Überprüfe, ob der Spieler sich in der Nähe einer Tankstelle befindet
if (count(nearestObjects [player,["Land_FuelStation_Feed_F","Land_fs_feed_F"],3.5]) isEqualTo 0) exitWith { hint localize "STR_ISTR_Jerry_Distance";};

// Überprüfe, ob eine Aktion bereits in Benutzung ist
if (life_action_inUse) exitWith {};

// Überprüfe, ob der Spieler nicht bereits eine Aktion durchführt und ob er nicht eingeschränkt oder ergriffen ist
if !(isNull objectParent player) exitWith {};
if (player getVariable "restrained") exitWith {hint localize "STR_NOTF_isrestrained";};
if (player getVariable "playerSurrender") exitWith {hint localize "STR_NOTF_surrender";};

// Holen Sie sich die Kosten für das Betanken aus den Einstellungen
_fuelCost = LIFE_SETTINGS(getNumber,"fuelCan_refuel");

// Setzen Sie die Aktion in Benutzung, um parallele Aktionen zu verhindern
life_action_inUse = true;

// Zeige eine Benutzernachricht an, um die Zustimmung des Spielers zur Aktion zu erhalten
_action = [
    format [localize "STR_ISTR_Jerry_PopUp",[_fuelCost] call life_fnc_numberText],
    localize "STR_ISTR_Jerry_StationPump",
    localize "STR_Global_Yes",
    localize "STR_Global_No"
] call BIS_fnc_guiMessage;

// Überprüfe, ob der Spieler zugestimmt hat
if (_action) then {
    // Überprüfe, ob der Spieler genug Geld hat
    if (CASH < _fuelCost) exitWith {hint localize "STR_NOTF_NotEnoughMoney"; life_action_inUse = false;};

    // Speichere die Startposition des Spielers für spätere Überprüfungen
    _startPos = getPos player;

    // Setup des Fortschrittsbalkens
    disableSerialization;
    "progressBar" cutRsc ["life_progress","PLAIN"];
    _title = localize "STR_ISTR_Jerry_Refuel";
    _ui = uiNamespace getVariable "life_progress";
    _progress = _ui displayCtrl 38201;
    _pgText = _ui displayCtrl 38202;
    _pgText ctrlSetText format ["%2 (1%1)...","%",_title];
    _progress progressSetPosition 0.01;
    _cP = 0.01;

    // Fortschrittsbalken-Schleife
    for "_i" from 0 to 1 step 0 do {
        // Synchronisieren Sie die Animation des Spielers
        if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
            [player,"AinvPknlMstpSnonWnonDnon_medic_1",true] remoteExecCall ["life_fnc_animSync",RCLIENT];
            player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
            player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
        };

        // Warten Sie kurz zwischen den Fortschrittsschritten
        uiSleep 0.2;

        // Überprüfen Sie die UI-Elemente
        if (isNull _ui) then {
            "progressBar" cutRsc ["life_progress","PLAIN"];
            _ui = uiNamespace getVariable "life_progress";
            _progressBar = _ui displayCtrl 38201;
            _titleText = _ui displayCtrl 38202;
        };

        // Aktualisieren Sie den Fortschrittsbalken
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_title];

        // Überprüfen Sie die Abbruchbedingungen
        if (_cP >= 1) exitWith {};
        if (!alive player) exitWith {};
        if (life_interrupted) exitWith {};
    };

    // Schließen Sie die UI-Elemente und überprüfen Sie verschiedene Zustände
    "progressBar" cutText ["","PLAIN"];
    player playActionNow "stop";

    // Überprüfen Sie, ob der Spieler noch lebt oder betäubt oder bewusstlos ist
    if (!alive player || life_istazed || life_isknocked) exitWith {life_action_inUse = false;};

    // Überprüfen Sie, ob der Spieler eingeschränkt ist
    if (player getVariable ["restrained",false]) exitWith {life_action_inUse = false;};

    // Überprüfen Sie, ob die Aktion unterbrochen wurde
    if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; life_action_inUse = false;};

    // Überprüfen Sie, ob der Spieler noch einen leeren Benzinkanister hat
    if (!([false,"fuelEmpty",1] call life_fnc_handleInv)) exitWith {life_action_inUse = false;};

    // Setzen Sie die Aktion als nicht in Benutzung
    life_action_inUse = false;

    // Ziehen Sie die Kraftstoffkosten vom Bargeld des Spielers ab
    CASH = CASH - _fuelCost;

    // Fügen Sie einen vollen Benzinkanister zum Inventar des Spielers hinzu
    [true,"fuelFull",1] call life_fnc_handleInv;

    // Zeigen Sie eine Benachrichtigung an, dass der Spieler erfolgreich betankt wurde
    hint localize "STR_ISTR_Jerry_Refueled";
} else {
    // Zeigen Sie eine Benachrichtigung an, dass der Spieler die Aktion abgebrochen hat
    hint localize "STR_NOTF_ActionCancel";

    // Schließen Sie das GUI-Fenster
    closeDialog 0;

    // Setzen Sie die Aktion als nicht in Benutzung
    life_action_inUse = false;
};
