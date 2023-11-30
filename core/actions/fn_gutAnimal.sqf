#include "..\..\script_macros.hpp"
/*
    File: fn_gutAnimal.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Guts the animal?
*/

params [
    ["_animalCorpse", objNull, [objNull]]
];

// Beende, wenn das Tierkadaverobjekt null ist
if (isNull _animalCorpse) exitWith {};

// Unterbrich, wenn der Spieler zu weit entfernt ist
if (player distance _animalCorpse > 3.5) exitWith {};

// Setze life_interrupted zurück
life_interrupted = false;

// Setze life_action_inUse auf true
life_action_inUse = true;

// Erhalte Informationen über das Tier aus dem Typ des Kadavers
private _animalInfo = switch (typeOf _animalCorpse) do {
    case "Hen_random_F": {["STR_ANIM_chicken", "hen_raw"]};
    case "Cock_random_F": {["STR_ANIM_Rooster", "rooster_raw"]};
    case "Goat_random_F": {["STR_ANIM_Goat", "goat_raw"]};
    case "Sheep_random_F": {["STR_ANIM_Sheep", "sheep_raw"]};
    case "Rabbit_F": {["STR_ANIM_Rabbit", "rabbit_raw"]};
    default {["", ""]};
};

// Extrahiere Namen und Gegenstandstyp aus den Tierinformationen
_animalInfo params ["_displayName", "_item"];

// Lokalisiere den Anzeigenamen des Tiers
_displayName = localize _displayName;

// Beende, wenn der Anzeigename leer ist
if (_displayName isEqualTo "") exitWith { life_action_inUse = false; };

// Setze den Fortschrittsbalken und die Texte
disableSerialization;
"progressBar" cutRsc ["life_progress", "PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...", "%", _displayName];
_progress progressSetPosition 0.01;
private _cP = 0.01;

// Schleife für die Fortschrittsanzeige
for "_i" from 0 to 1 step 0 do {
    if (animationState player != "AinvPknlMstpSnonWnonDnon_medic_1") then {
        [player, "AinvPknlMstpSnonWnonDnon_medic_1", true] remoteExecCall ["life_fnc_animSync", RCLIENT];
        player switchMove "AinvPknlMstpSnonWnonDnon_medic_1";
        player playMoveNow "AinvPknlMstpSnonWnonDnon_medic_1";
    };
    uiSleep 0.15;
    _cP = _cP + 0.01;
    _progress progressSetPosition _cP;
    _pgText ctrlSetText format ["%3 (%1%2)...", round(_cP * 100), "%", _displayName];
    if (_cP >= 1) exitWith {};
    if (!alive player) exitWith {};
    if (isNull _animalCorpse) exitWith {};
    if (!(isNull objectParent player)) exitWith {};
    if (life_interrupted) exitWith {};
};

// Setze life_action_inUse zurück
life_action_inUse = false;

// Schneide den Fortschrittsbalken ab
"progressBar" cutText ["", "PLAIN"];

// Stoppe die Aktion des Spielers
player playActionNow "stop";

// Beende, wenn das Tierkadaverobjekt null ist
if (isNull _animalCorpse) exitWith { life_action_inUse = false; };

// Beende, wenn life_interrupted aktiviert wurde
if (life_interrupted) exitWith { life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel", "PLAIN"]; life_action_inUse = false; };

// Beende, wenn der Spieler sich in einem Fahrzeug befindet
if (!(isNull objectParent player)) exitWith { titleText[localize "STR_NOTF_ActionInVehicle", "PLAIN"]; };

// Verarbeite den Gegenstand im Inventar des Spielers
if ([true, _item, 1] call life_fnc_handleInv) then {
    // Führe Crafting-Funktion aus (Beispielwert)
    [60, 0, 5] call cat_craftingV2_fnc_randomPlan;

    // Lösche das Tierkadaverobjekt
    deleteVehicle _animalCorpse;

    // Zeige Erfolgsmeldung
    titleText[format [(localize "STR_NOTF_Guttingfinish"), _displayName], "PLAIN"];
} else {
    // Zeige Benachrichtigung bei vollem Inventar
    titleText[(localize "STR_NOTF_InvFull"), "PLAIN"];
};
