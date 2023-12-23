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

// Definiere Sirenen-Soundklassen für Polizei (West) und Sanitäter (Independent)
private _sirenClassesWest = ["sirenLong", "sirenShort"];
private _sirenClassesIndependent = ["medicSiren1", "medicSiren2"];

// Liste der erlaubten Fahrzeugtypen für Sirenen
private _allowedVehicleTypes = ["C_Offroad_01_F", "B_MRAP_01_F", "C_SUV_01_F", "C_Hatchback_01_sport_F"];

// Überprüfe, ob das aktuelle Fahrzeug in der Liste der erlaubten Fahrzeugtypen ist
if (typeOf _vehicle in _allowedVehicleTypes && !(isKindOf _vehicle, "Air")) then {
    // Wähle die Sirenensoundklassen basierend auf der Fraktion des Fahrzeugs
    private _sirenClasses = switch (side _vehicle) do {
        case WEST: { _sirenClassesWest };
        case INDEPENDENT: { _sirenClassesIndependent };
        default { [] };
    };

    // Unendliche Schleife für die Sirenensound-Wiedergabe
    while {alive _vehicle} do {
        if !(_vehicle getVariable "siren") exitWith {}; // Beende, wenn die Sirene im Fahrzeug ausgeschaltet ist
        if (crew _vehicle isEqualTo []) then {
            _vehicle setVariable ["siren", false, true]; // Setze die Sirenenvariable auf false, wenn keine Besatzung im Fahrzeug ist
        };

        // Überprüfe die Tastenbelegung für die Sirenensteuerung
        private _sirenKey = if (keyPressed 0x21) then { "Ctrl + F" } else { "F" };

        // Spiele den entsprechenden Sirenensound ab
        private _selectedSiren = if (_sirenKey isEqualTo "Ctrl + F") then {
            if (_sirenClasses isEqualTo ["sirenShort", "medicSiren2"]) then { "medicSiren2" } else { "sirenShort" }
        } else {
            if (_sirenClasses isEqualTo ["sirenLong", "medicSiren1"]) then { "medicSiren1" } else { "sirenLong" }
        };

        _vehicle say3D [_selectedSiren, 1000, 1]; // Maximale Entfernung & Tonhöhe
        Sleep 4.870; // Genau die Länge der Audiodatei, um den Klang zu synchronisieren
    };
} else {
    hint "Dieser Fahrzeugtyp ist nicht mit Sirene ausgestattet.";
};
