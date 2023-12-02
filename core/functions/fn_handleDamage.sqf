#include "..\..\script_macros.hpp"
/*
    File: fn_handleDamage.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Diese Funktion behandelt den Schaden, speziell für den Umgang mit der 'Taser'-Pistole und nichts anderem.

    Parameter:
    _unit: Die Einheit, die den Schaden erleidet.
    _part: Der Körperteil, der betroffen ist (optional).
    _damage: Die Menge des Schadens (optional).
    _source: Die Quelle des Schadens (optional).
    _projectile: Der Projektiltyp (optional).
    _index: Der Index (optional).

    Rückgabewert:
    Der durchgeführte Schaden.
*/

params [
    ["_unit", objNull, [objNull]],
    ["_part", "", [""]],
    ["_damage", 0, [0]],
    ["_source", objNull, [objNull]],
    ["_projectile", "", [""]],
    ["_index", 0, [0]]
];

// Überprüfen, ob _source nicht null ist und nicht mit _unit übereinstimmt
if (!isNull _source && {_source != _unit}) then {
    // Überprüfen, ob _source auf der Seite west ist und die richtige Waffe und Projektil verwendet
    if (side _source isEqualTo west) then {
        if (currentWeapon _source in ["hgun_P07_snds_F", "arifle_SDAR_F"] && _projectile in ["B_9x21_Ball", "B_556x45_dual"]) then {
            // Überprüfen, ob _unit lebendig ist und nicht bereits getasert wurde
            if (alive _unit) then {
                // Wenn _unit auf der Seite der Zivilisten ist und noch nicht getasert wurde
                if (playerSide isEqualTo civilian && {!life_istazed}) then {
                    private _distance = 35;
                    // Wenn das Projektil ein Dual-Projektil ist, ändere die Distanz
                    if (_projectile isEqualTo "B_556x45_dual") then {_distance = 100};
                    // Überprüfen, ob die Entfernung zwischen _unit und _source klein genug ist
                    if (_unit distance _source < _distance) then {
                        // Wenn _unit sich in einem Fahrzeug befindet
                        if !(isNull objectParent _unit) then {
                            // Wenn das Fahrzeug ein Quadbike ist, werfe die Einheit aus und rufe die Tazed-Funktion auf
                            if (typeOf (vehicle _unit) isEqualTo "B_Quadbike_01_F") then {
                                _unit action ["Eject", vehicle _unit];
                                [_unit, _source] spawn life_fnc_tazed;
                            };
                        } else {
                            // Wenn _unit nicht in einem Fahrzeug ist, rufe die Tazed-Funktion auf
                            [_unit, _source] spawn life_fnc_tazed;
                        };
                    };
                };
                // Aktualisiere den verursachten Schaden basierend auf dem betroffenen Körperteil oder allgemeinem Schaden
                _damage = if (_part isEqualTo "") then {
                    damage _unit;
                } else { 
                    _unit getHit _part;
                };
            };
        };
    };
};

// Rufe die Funktion zum Aktualisieren der HUD-Anzeige auf
[] spawn life_fnc_hudUpdate;

// Gib den durchgeführten Schaden zurück
_damage;
