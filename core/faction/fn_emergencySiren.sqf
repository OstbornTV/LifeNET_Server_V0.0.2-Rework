/*
    File: fn_emergencySiren.sqf
    Author: OsbornTV

    Description:
    Starts the emergency vehicle siren sound for other players.
*/

params [
    ["_vehicle", objNull, [objNull]],
    ["_sirenType", "", ""]
];

if (isNull _vehicle) exitWith {}; // Beende, wenn das Fahrzeug nicht existiert
if (isNil {_vehicle getVariable "siren"}) exitWith {}; // Beende, wenn die Sirene im Fahrzeug nicht existiert

// Definiere Sirenen-Soundklassen für Polizei (West) und Sanitäter (independent)
private _sirenClassesWest = ["sirenLong", "sirenShort", "sirenManual"];
private _sirenClassesMedics = ["medicSiren1", "medicSiren2", "medicSiren3"];

// Wähle die Sirenensoundklassen basierend auf dem Sirentyp (_sirenType)
private _sirenClasses = switch (_sirenType) do {
    case "west": { _sirenClassesWest };
    case "independent": { _sirenClassesMedics };
    default { [] };
};

// Unendliche Schleife für die Sirenensound-Wiedergabe
while {alive _vehicle} do {
    if !(_vehicle getVariable "siren") exitWith {}; // Beende, wenn die Sirene im Fahrzeug ausgeschaltet ist
    if (crew _vehicle isEqualTo []) then {
        _vehicle setVariable ["siren", false, true]; // Setze die Sirenenvariable auf false, wenn keine Besatzung im Fahrzeug ist
    };

    // Spiele zufällige Sirenensoundklasse ab
    private _randomSiren = _sirenClasses call BIS_fnc_selectRandom;
    _vehicle say3D [_randomSiren, 500, 1]; // Maximale Entfernung & Tonhöhe
    uiSleep 4.870; // Genau die Länge der Audiodatei, um den Klang zu synchronisieren
};
