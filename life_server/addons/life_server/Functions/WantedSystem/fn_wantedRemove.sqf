/*
    File: fn_wantedRemove.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Removes a person from the wanted list.
*/

params [
    ["_uid", "", [""]]
];

// Überprüfen auf ungültige Daten
if (_uid isEqualTo "") exitWith {"Error: Invalid UID."};

// Datenbankabfrage, um die Person mit der angegebenen UID aus der wanted-Liste zu entfernen
private _query = format ["deleteWanted:%1", _uid];
[_query, 2] call DB_fnc_asyncCall;
