#include "..\..\script_macros.hpp"
/*
    File: fn_jerryRefuel.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Refuels the vehicle if the player has a fuel can.
*/

// Holen Sie sich das Fahrzeug, auf das der Cursor zeigt
private _vehicle = cursorObject;

// Überprüfen Sie verschiedene Bedingungen, um festzustellen, ob die Aktion fortgesetzt werden kann
life_interrupted = false;
if (isNull _vehicle) exitWith {hint localize "STR_ISTR_Jerry_NotLooking"};
if (!(_vehicle isKindOf "LandVehicle") && !(_vehicle isKindOf "Air") && !(_vehicle isKindOf "Ship")) exitWith {};
if (player distance _vehicle > 7.5) exitWith {hint localize "STR_ISTR_Jerry_NotNear"};

// Setzen Sie die Aktion in Benutzung, um parallele Aktionen zu verhindern
life_action_inUse = true;

// Holen Sie sich den Anzeigenamen des Fahrzeugs aus den Konfigurationen
private _displayName = FETCH_CONFIG2(getText,"CfgVehicles",(typeOf _vehicle),"displayName");

// Benutzerfreundliche Fortschrittsanzeige
private _upp = format [localize "STR_ISTR_Jerry_Process",_displayName];

// Fortschrittsbalken initialisieren
disableSerialization;
"progressBar" cutRsc ["life_progress","PLAIN"];
private _ui = uiNamespace getVariable "life_progress";
private _progress = _ui displayCtrl 38201;
private _pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
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
    _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];

    // Überprüfen Sie die Abbruchbedingungen
    if (_cP >= 1) exitWith {};
    if (!alive player) exitWith {};
    if (life_interrupted) exitWith {};
};

// Setzen Sie die Aktion als nicht in Benutzung
life_action_inUse = false;

// Schließen Sie die Fortschrittsanzeige und die Animation des Spielers
"progressBar" cutText ["","PLAIN"];
player playActionNow "stop";

// Überprüfen Sie, ob der Spieler noch lebt oder betäubt oder bewusstlos ist
if (!alive player) exitWith {};

// Überprüfen Sie, ob die Aktion unterbrochen wurde
if (life_interrupted) exitWith {life_interrupted = false; titleText[localize "STR_NOTF_ActionCancel","PLAIN"]; [true,"fuelFull",1] call life_fnc_handleInv;};

// Überprüfen Sie, ob der Spieler einen vollen Benzinkanister hat
if !([false,"fuelFull",1] call life_fnc_handleInv) exitWith {};

// Berechnen Sie die Menge an Kraftstoff, die dem Fahrzeug hinzugefügt wird
private _fuelAmount = call {
    if (_vehicle isKindOf "LandVehicle") exitWith {0.5};
    if (_vehicle isKindOf "Air") exitWith {0.2};
    0.35
};

// Aktualisieren Sie den Kraftstoffstand des Fahrzeugs
private _newFuel = (fuel _vehicle) + _fuelAmount;
if (local _vehicle) then {
    _vehicle setFuel _newFuel;
} else {
    [_vehicle,_newFuel] remoteExecCall ["life_fnc_setFuel",_vehicle];
};

// Erfolgsmeldung anzeigen
titleText[format [localize "STR_ISTR_Jerry_Success",_displayName],"PLAIN"];

// Leeren Benzinkanister aus dem Inventar entfernen
[true,"fuelEmpty",1] call life_fnc_handleInv;
