#include "..\..\script_macros.hpp"
/*
    File: fn_fedCamDisplay.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Turns on and displays a security cam-like feed via PiP to the laptop display.
*/
params [
    "_laptop",
    "", // Diese Parameter erscheinen nicht verwendet zu werden
    "",
    "_mode"
];

// Array mit Position des Domes
private _wl_roscheArray = [16019.5,16952.9,0];

// Position des Domes auf der Karte finden
private _pos = [[["WL_Rosche", _wl_roscheArray]]] call life_util_fnc_terrainSort;

// Nächstgelegenes Objekt zum gefundenen Punkt (Dome)
private _dome = nearestObject [_pos,"Land_Dome_Big_F"];

// Wenn Picture-in-Picture (PiP) deaktiviert ist, Meldung anzeigen und abbrechen
if (!isPiPEnabled) exitWith {hint localize "STR_Cop_EnablePiP";};

// Wenn life_fed_scam noch nicht erstellt wurde, erstelle es und konfiguriere die Kamera
if (isNil "life_fed_scam") then {
    life_fed_scam = "camera" camCreate [0,0,0];
    life_fed_scam camSetFov 0.5;
    life_fed_scam camCommit 0;
    "rendertarget0" setPiPEffect [0];
    life_fed_scam cameraEffect ["INTERNAL", "BACK", "rendertarget0"];
    _laptop setObjectTexture [0,"#(argb,256,256,1)r2t(rendertarget0,1.0)"];
};

// Positionen für verschiedene Modi und deren Namen
private _mTwPositions = [
    ["side",[16.9434,-0.300781,-7.20004],[27.0693,-0.390625,-10.2474]],
    ["vault",[19.9775,-0.0078125,-1.90735e-006],[-5.00684,0.59375,-9.57164]],
    ["front",[0.972656,78.8281,15.617],[-0.657227,22.9082,-10.4033]],
    ["back",[28.9248,-42.0977,-3.8896],[-1.33789,-24.6035,-10.2108]]
]; // modelToWorld-Positionen

// Index des gewählten Modus finden
private _index = [_mode,_mTwPositions] call life_util_fnc_index;

// Wenn der Index -1 ist, schalte die Kamera aus
if (_index isEqualTo -1) then {
    life_fed_scam cameraEffect ["terminate", "back"];
    camDestroy life_fed_scam;
    _laptop setObjectTexture [0,""];
    life_fed_scam = nil;
} else {
    // Andernfalls setze die Position und das Ziel der Kamera entsprechend dem gewählten Modus
    private _temp = _mTwPositions select _index;
    life_fed_scam camSetPos (_dome modelToWorld (_temp select 1));
    life_fed_scam camSetTarget (_dome modelToWorld (_temp select 2));
    life_fed_scam camCommit 0;
};
