#include "..\..\script_macros.hpp"
/*
    File : fn_placestorage.sqf
    Author: NiiRoZz

    Description:
    Place container where player selects with preview
*/

// Überprüfen Sie, ob Container aktiviert ist
if (!life_container_active) exitWith {};
if (life_container_activeObj isEqualTo objNull) exitWith {};

// Überprüfen Sie den Container-Typ
private _container = life_container_activeObj;
if (!((typeOf _container) in ["B_supplyCrate_F","Box_IND_Grenades_F"])) exitWith {};

// Initialisieren von Variablen
private _isFloating = if (((getPos _container) select 2) < 0.1) then {false} else {true};

// Container vom ursprünglichen Objekt trennen
detach _container;

// Temporäres Deaktivieren der Physiksimulation des Containers
[_container,true] remoteExecCall ["life_fnc_simDisable",RANY];

// Container um 0.7 Meter anheben
_container setPosATL [getPosATL _container select 0, getPosATL _container select 1, (getPosATL _container select 2) + 0.7];

// Schaden am Container deaktivieren und Seilbefestigung deaktivieren
_container allowDamage false;
_container enableRopeAttach false;

// Je nach Container-Typ das Inventar des Spielers aktualisieren
if ((typeOf _container) == "B_supplyCrate_F") then {
    [false,"storagebig",1] call life_fnc_handleInv;
} else {
    [false,"storagesmall",1] call life_fnc_handleInv;
}

// Container platzieren und Vorschau beenden
[_container, _isFloating] call life_fnc_placeContainer;

// Zurücksetzen der Container-Statusvariablen
life_container_active = false;
life_container_activeObj = objNull;
