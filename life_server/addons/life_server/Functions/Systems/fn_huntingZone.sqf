/*
    File: fn_huntingZone.sqf
    Author: Bryan "Tonic" Boardwine

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

// Überprüfe, ob es bereits Tiere gibt, und verringere die maximale Anzahl entsprechend
if (!isNil "animals" && {!(count animals isEqualTo 0)}) then {
    _maxAnimals = _maxAnimals - count(animals);
} else {
    animals = [];
};

_unitsNear = false;
_animalsActive = false;

for "_i" from 0 to 1 step 0 do {
    // Überprüfe, ob sich spielbare Einheiten in der Nähe befinden
    { if ((_x distance _zone) < _dist) exitWith { _unitsNear = true; }; _unitsNear = false; } forEach playableUnits;

    // Wenn spielbare Einheiten in der Nähe sind und keine Tiere aktiv sind, spawne Tiere
    if (_unitsNear && !_animalsActive) then {
        _animalsActive = true;
        for "_j" from 1 to _maxAnimals do {
            _animalClass = selectRandom _animalList;
            _position = [_zone select 0, _zone select 1, 0];
            _position set [0, (_position select 0) - _radius + random (_radius * 2)];
            _position set [1, (_position select 1) - _radius + random (_radius * 2)];
            _animal = createAgent [_animalClass, _position, [], 0, "FORM"];
            _animal setDir (random 360);
            animals pushBack _animal;
        };
    } else {
        // Wenn keine spielbaren Einheiten in der Nähe sind und Tiere aktiv sind, lösche die Tiere
        if (!_unitsNear && _animalsActive) then {
            { deleteVehicle _x; } forEach animals;
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

    // Warte für eine zufällige Zeitspanne (3 bis 5 Sekunden) vor der nächsten Überprüfung
    uiSleep (3 + random 2);
    
    // Setze die maximale Anzahl der Tiere auf den Standardwert zurück
    _maxAnimals = param [1, 10, [0]];
};