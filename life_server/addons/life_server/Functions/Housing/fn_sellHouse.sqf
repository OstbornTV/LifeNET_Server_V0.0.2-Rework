/*
    File: fn_sellHouse.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Wird beim Verkauf des Hauses verwendet, setzt den Eigentümer auf 0
    und bereinigt es mit einer gespeicherten Prozedur beim Neustart.
*/

params [
    ["_house", objNull, [objNull]]
];

// Beende mit einer Meldung, wenn das Haus ungültig ist
if (isNull _house) exitWith {systemChat ":SERVER:sellHouse: House is null";};

// Ermittle die Haus-ID aus der Haus-Variable
private _houseID = _house getVariable ["house_id", -1];

private "_query";

// Überprüfe, ob die Haus-ID ungültig ist
if (_houseID isEqualTo -1) then {
    // Das Haus hat keine gültige Haus-ID, daher wird es durch die Position und den Besitzer gelöscht
    private _housePos = getPosATL _house;
    private _ownerID = (_house getVariable "house_owner") select 0;
    _query = format ["deleteHouse:%1:%2", _ownerID, _housePos];
} else {
    // Das Haus hat eine gültige Haus-ID, daher wird es durch die ID gelöscht
    _query = format ["deleteHouse1:%1", _houseID];
};

// Setze die Variablen im Haus zurück
_house setVariable ["house_id", nil, true];
_house setVariable ["house_owner", nil, true];
_house setVariable ["garageBought", false, true];

// Führe die Datenbankabfrage asynchron aus
[_query, 1] call DB_fnc_asyncCall;

// Setze die Variable "house_sold" im Haus zurück
_house setVariable ["house_sold", nil, true];

// Starte die gespeicherte Prozedur zum Löschen alter Häuser
["deleteOldHouses", 1] call DB_fnc_asyncCall;
