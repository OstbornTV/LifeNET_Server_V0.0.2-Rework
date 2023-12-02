#include "..\..\script_macros.hpp"

/*
    File : fn_storageBox.sqf
    Author: NiiRoZz
    Description: Create Storage and attach to player;
*/

// Private Variablen deklarieren
private ["_object", "_attachPos"];

// Parameter für die Größe der Storage Box festlegen
params [["_size", false, [false]]];

// Überprüfen, ob sich der Spieler in einem Haus befindet
if (!(nearestObject [player, "House"] in life_vehicles)) exitWith {
    hint localize "STR_ISTR_Box_NotinHouse";
};

// Aktive Storage Box-Variable setzen
life_container_active = true;

// Dialog schließen
closeDialog 0;

// Je nach Größe die entsprechende Storage Box erstellen
if (_size) then {
    _object = "B_supplyCrate_F" createVehicle [0, 0, 0];
} else {
    _object = "Box_IND_Grenades_F" createVehicle [0, 0, 0];
};

// Aktive Storage Box-Objekt setzen
life_container_activeObj = _object;

// Attach-Position festlegen
_attachPos = [0.16, 3, ((boundingBoxReal _object) select 1) select 2];

// Simulation für das Objekt deaktivieren
[_object] remoteExecCall ["life_fnc_simDisable", RANY];

// Storage Box an den Spieler anhängen
_object attachTo [player, _attachPos];

// Waffen, Magazine, Items und Rucksack-Inhalte der Storage Box löschen
clearWeaponCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearItemCargoGlobal _object;
clearBackpackCargoGlobal _object;

// Benachrichtigung über das Platzieren der Storage Box
titleText [localize "STR_NOTF_PlaceContainer", "PLAIN"];
