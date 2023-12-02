#include "..\..\script_macros.hpp"
/*
    File: fn_revived.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    DANKESCHÖN, ICH BIN GESCHENKT WORDEN!
*/
private ["_medic", "_dir", "_reviveCost"];
_medic = param [0, "Unbekannter Sanitäter", [""]];
_reviveCost = LIFE_SETTINGS(getNumber, "revive_fee");

// Setze das Spieler-Loadout auf das gespeicherte Loadout vor dem Tod zurück
player setUnitLoadout life_save_gear;

// Zeige eine Benachrichtigung über die Revive-Gebühr
hint format [localize "STR_Medic_RevivePay", _medic, [_reviveCost] call life_fnc_numberText];

// Schließe das Dialogfenster und beende den Todeskameraeffekt
closeDialog 0;
life_deathCamera cameraEffect ["TERMINATE", "BACK"];
camDestroy life_deathCamera;

// Ziehe die Gebühr für die medizinische Versorgung ab
if (BANK > _reviveCost) then {
    BANK = BANK - _reviveCost;
} else {
    BANK = 0;
}

// Bringe den Spieler wieder zum Leben
player setDir (getDir life_corpse);
player setPosASL (visiblePositionASL life_corpse);
life_corpse setVariable ["realname", nil, true]; // Korrigiert das Problem mit dem doppelten Namen, der im Boden versinkt
life_corpse setVariable ["Revive", nil, true];
life_corpse setVariable ["name", nil, true];
[life_corpse] remoteExecCall ["life_fnc_corpse", RANY];
deleteVehicle life_corpse;

life_action_inUse = false;
life_is_alive = true;

// Setze die Spieler-Variablen zurück
player setVariable ["Revive", nil, true];
player setVariable ["name", nil, true];
player setVariable ["Reviving", nil, true];

// Aktualisiere das Spieler-Aussehen und die HUD-Anzeige
[] call life_fnc_playerSkins;
[] call life_fnc_hudUpdate; // Anforderung einer Aktualisierung des HUD
[] call SOCK_fnc_updateRequest;
