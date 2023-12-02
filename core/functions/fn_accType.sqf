#include "..\..\script_macros.hpp"
/*
    File: fn_accType.sqf
    Author: Bryan "Tonic" Boardwine

    *Funktionalität des Virtual Ammobox Systems*

    Beschreibung:
    Überprüft, welche Art von Zubehör übergeben wird und wofür es kompatibel ist.
    Sollte nun mit der neuen Struktur der compatibleItems-Klasse kompatibel sein. Dies war keine angenehme Aufgabe, aber zum Glück
    hat mir Robalo einige Codes gegeben, die mir den Weg gezeigt haben. Wenn es nicht zu 100% kompatibel ist, weiß ich es nicht. Das forEach in einem forEach hat mich verrückt gemacht und
    nicht der beste Weg, Dinge zu tun. Ich weiß wirklich nicht, was ich dachte, aber zwei Wochen PHP-Code zu schreiben und GTA V zu spielen, neigt dazu, dich Dinge vergessen zu lassen... Wow, was für ein Geschwätz... blah blah blah.

    Rückgabewerte:
    0: Unbekannter Fehler
    1: Primär
    2: Sekundär
    3: Handfeuerwaffe
*/

private ["_item", "_type", "_ret", "_weaponArray"];
_item = [_this, 0, "", [""]] call BIS_fnc_param;
_type = [_this, 1, 0, [0]] call BIS_fnc_param;

// Überprüfe auf leere Zeichenfolge oder ungültigen Typ
if (_item isEqualTo "" || _type isEqualTo 0) exitWith {0};

_ret = 0;
_weaponArray = [primaryWeapon player, secondaryWeapon player, handgunWeapon player];

{
    // Stelle sicher, dass wir die Schleife verlassen, wenn bereits eine Übereinstimmung vorhanden ist.
    if (!(_ret isEqualTo 0)) exitWith {};

    if (!(_x isEqualTo "")) then {
        _weapon = _x;
        _cfgInfo = [_weapon, "CfgWeapons"] call life_fnc_fetchCfgDetails;

        _legacyItems = ((_cfgInfo select 10) + (_cfgInfo select 11) + (_cfgInfo select 12));
        _newItems = _cfgInfo select 14;

        // Überprüfe zuerst Legacy-Items
        if (count _legacyItems > 0) then {
            for "_i" from 0 to (count _legacyItems) - 1 do {
                _legacyItems set [_i, toLower(_legacyItems select _i)];
            };

            // Überprüfe, ob das Item in den Legacy-Items enthalten ist
            if ((toLower _item) in _legacyItems) exitWith {
                _ret = switch (_weapon) do {
                    case (primaryWeapon player): {1};
                    case (secondaryWeapon player): {2};
                    case (handgunWeapon player): {3};
                    default {0};
                };
            };
        };

        // Überprüfe neue compatibleItems-Klassenstruktur
        if (count _newItems > 0) then {
            // Dies wird mit forEach in forEach etwas kompliziert
            {
                // Stelle sicher, dass wir die Schleife verlassen, wenn bereits eine Übereinstimmung vorhanden ist.
                if (!(_ret isEqualTo 0)) exitWith {};

                // Überprüfe, ob die compatibleItems-Klasse in der Konfiguration vorhanden ist
                if (isClass (configFile >> "CfgWeapons" >> _weapon >> "WeaponSlotsInfo" >> _x >> "compatibleItems")) then {
                    _cfg = FETCH_CONFIG4(getNumber, "CfgWeapons", _weapon, "WeaponSlotsInfo", _x, "compatibleItems", _item);
                };

                // Setze _cfg auf 0, wenn es nicht definiert ist
                if (isNil "_cfg") then {_cfg = 0;};

                // Wenn _cfg gleich 1 ist, setze den Rückgabewert entsprechend
                if (_cfg isEqualTo 1) exitWith {
                    _ret = switch (_weapon) do {
                        case (primaryWeapon player): {1};
                        case (secondaryWeapon player): {2};
                        case (handgunWeapon player): {3};
                        default {0};
                    };
                };
            } forEach _newItems;

            // Stelle sicher, dass wir die Schleife verlassen, wenn bereits eine Übereinstimmung vorhanden ist.
            if (!(_ret isEqualTo 0)) exitWith {};
        };
    };
} forEach _weaponArray;

_ret;
