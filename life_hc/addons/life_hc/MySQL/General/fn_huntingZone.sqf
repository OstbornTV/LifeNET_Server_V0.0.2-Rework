/*
    File: fn_huntingZone.sqf
    Author: Bryan "Tonic" Boardwine

    This file is for Nanou's HeadlessClient.

    Description:
    Spawns animals around the marker when a player
    is near. Very basic WIP

    TODO:
    Change it up so animals repopulate over time.
*/

private ["_animalList", "_dist", "_radius", "_zoneName", "_unitsNear", "_animalsActive"];
params [
    ["_zoneName", "", [""]],
    ["_maxAnimals", 10, [0]]
];

if (_zoneName isEqualTo "") exitWith {};
_animalList = ["Sheep_random_F", "Goat_random_F", "Hen_random_F", "Cock_random_F"];
_radius = (getMarkerSize _zoneName) select 0;
_dist = _radius + 100;
_zone = getMarkerPos _zoneName;

// Überprüfen, ob es bereits aktive Tiere gibt
if (!isNil "animals" && {!(count animals isEqualTo 0)}) then {
    _maxAnimals = _maxAnimals - count(animals);
} else {
    animals = [];
};

_unitsNear = false;
_animalsActive = false;

// Hauptschleife
for "_i" from 0 to 1 step 0 do {
    // Überprüfen, ob sich spielbare Einheiten in der Nähe des Markers befinden
    {
        if ((_x distance _zone) < _dist) exitWith {_unitsNear = true;};
        _unitsNear = false;
    } forEach playableUnits;

    // Tiere aktivieren, wenn Spieler in der Nähe sind
    if (_unitsNear && !_animalsActive) then {
        _animalsActive = true;

        // Tiere erstellen
        for "_i" from 1 to _maxAnimals do {
            _animalClass = selectRandom _animalList;
            _position = [((_zone select 0) - _radius + random (_radius * 2)), ((_zone select 1) - _radius + random (_radius * 2)), 0];
            _animal = createAgent [_animalClass, _position, [], 0, "FORM"];
            _animal setDir (random 360);
            animals pushBack _animal;
        };
    } else {
        // Tiere deaktivieren, wenn keine Spieler in der Nähe sind
        if (!_unitsNear && _animalsActive) then {
            {deleteVehicle _x;} forEach animals;
            animals = [];
            _animalsActive = false;
        };
    };

        // Repopulation implementieren
    if ((_i * 3) >= _repopulateInterval) then {
        {
            if (count animals < _maxAnimals) then {
                _animalClass = selectRandom _animalList;
                _position = [((_zone select 0) - _radius + random (_radius * 2)), ((_zone select 1) - _radius + random (_radius * 2)), 0];
                _animal = createAgent [_animalClass, _position, [], 0, "FORM"];
                _animal setDir (random 360);
                animals pushBack _animal;
            };
        } forEach [0, 0, 0]; // Dieser Loop könnte mehrfach durchlaufen werden, um die Anzahl der Tiere zu erhöhen
    };

    // Wartezeit zwischen den Schleifen
    sleep (3 + random 2);
    _maxAnimals = param [1, 10, [0]];

    // Server über aktualisierte Tiere informieren
    publicVariableServer "animals";
};
