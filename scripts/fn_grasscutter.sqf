/*
  Diese Funktion erstellt einen "ClutterCutter" (Grass Cutter) an Positionen innerhalb eines Auslösers (_trig).
  Der Grass Cutter wird in regelmäßigen Abständen (_xpos und _ypos) platziert.
*/

// Der Auslöser und die Startposition werden aus den Parametern extrahiert
_trig = _this select 0;
_xpos = _this select 1;
_ypos = _this select 2;
_start = getPos _trig;

// Warten, bis die Funktionen initialisiert sind
waitUntil { not(isNil "BIS_fnc_init") };

// Schleife für die X-Positionen
for "_x" from -_xpos to _xpos step 4 do {
    // Schleife für die Y-Positionen
    for "_i" from -_ypos to _ypos step 4 do {
        // Neue Position berechnen
        _newpos = [_start select 0 + _x, _start select 1 + _i, 0];

        // Überprüfen, ob die neue Position im Auslöser liegt
        if ([_trig, _newpos] call BIS_fnc_inTrigger) then {
            // Grass Cutter erstellen, wenn die Position im Auslöser liegt
            null = createVehicle ["Land_ClutterCutter_large_F", _newpos, [], 0, "can_collide"];
        };
    };
};
