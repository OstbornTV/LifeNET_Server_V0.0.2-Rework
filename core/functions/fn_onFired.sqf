/*
    File: fn_onFired.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Verarbeitet verschiedene Arten von abgefeuerten Munitionstypen.
*/
private ["_ammoType","_projectile"];

// Extrahiere den Munitionstyp und das Projektil aus den übergebenen Parametern
_ammoType = _this select 4;
_projectile = _this select 6;

// Überprüfe, ob es sich um eine Handgranate (GrenadeHand_stone) handelt
if (_ammoType isEqualTo "GrenadeHand_stone") then {
    // Wenn ja, starte einen Spawnprozess für das Projektil
    _projectile spawn {
        private "_position";
        
        // Schleife, die die Position des Projektils in ASL-to-ATL umwandelt
        while {!isNull _this} do {
            _position = ASLtoATL (visiblePositionASL _this);
            sleep 0.1;
        };
        
        // Führe die Funktion für den Blendgranaten-Effekt auf dem Client aus
        [_position] remoteExec ["life_fnc_flashbang", RCLIENT];
    };
};
