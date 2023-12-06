/*
    File: fn_keyManagement.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Keeps track of an array locally on the server of a player's keys.
*/

// Funktion zum Verwalten der Schlüssel
private ["_uid", "_side", "_input", "_mode", "_arr"];

// Extrahiere Parameter
_uid = [_this, 0, "", [""]] call BIS_fnc_param;
_side = [_this, 1, sideUnknown, [sideUnknown]] call BIS_fnc_param;
_mode = [_this, 3, 0, [0]] call BIS_fnc_param;

// Fehlerüberprüfung: Beende die Funktion, wenn UID oder Seite unbekannt ist
if (_uid isEqualTo "" || _side isEqualTo sideUnknown) exitWith {"Error: Invalid UID or side."};

// Hauptswitch-Case für verschiedene Modi
switch _mode do {
    // Modus 0: Setze die Schlüssel für einen Spieler
    case 0: {
        _input = [_this, 2, [], [[]]] call BIS_fnc_param;
        _arr = [];

        // Iteriere über die Eingabe und füge nicht-nulle Objekte zum Array hinzu
        {
            if (!isNull _x && {!(_x isKindOf "House")}) then {
                _arr pushBack _x;
            };
        } forEach _input;

        // Entferne Null-Objekte aus dem Array
        _arr = _arr - [objNull];

        // Setze die Schlüssel für den Spieler in der Mission-Namespace
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], _arr];
    };

    // Modus 1: Füge einen Schlüssel für einen Spieler hinzu
    case 1: {
        _input = [_this, 2, objNull, [objNull]] call BIS_fnc_param;

        // Beende die Funktion, wenn der Schlüssel null ist oder ein Haus ist
        if (isNull _input || _input isKindOf "House") exitWith {"Error: Invalid key input."};

        // Hole das aktuelle Array der Schlüssel des Spielers
        _arr = missionNamespace getVariable [format ["%1_KEYS_%2", _uid, _side], []];

        // Füge den neuen Schlüssel zum Array hinzu und entferne Null-Objekte
        _arr pushBack _input;
        _arr = _arr - [objNull];

        // Setze das aktualisierte Array in der Mission-Namespace zurück
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], _arr];
    };

    // Modus 2: Entferne Null-Objekte aus dem Schlüssel-Array eines Spielers
    case 2: {
        // Hole das aktuelle Array der Schlüssel des Spielers
        _arr = missionNamespace getVariable [format ["%1_KEYS_%2", _uid, _side], []];

        // Entferne Null-Objekte aus dem Array
        _arr = _arr - [objNull];

        // Setze das aktualisierte Array in der Mission-Namespace zurück
        missionNamespace setVariable [format ["%1_KEYS_%2", _uid, _side], _arr];
    };
};
