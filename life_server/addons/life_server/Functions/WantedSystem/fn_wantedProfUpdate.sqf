#include "\life_server\script_macros.hpp"
/*
    File: fn_wantedProfUpdate.sqf
    Author: [midgetgrimm]
    Persistence by: ColinM
    Description:
    Updates the name of a player if they change profiles
*/

params [
    ["_uid", "", [""]],
    ["_name", "", [""]]
];

// Überprüfen auf ungültige Daten
if (_uid isEqualTo "" || {_name isEqualTo ""}) exitWith {};

// Datenbankabfrage, um den aktuellen Namen für die angegebene UID zu erhalten
private _wantedCheck = format ["selectWantedName:%1", _uid];
private _wantedQuery = [_wantedCheck, 2] call DB_fnc_asyncCall;

// Überprüfen, ob die Datenbankabfrage Ergebnisse liefert
if (_wantedQuery isEqualTo []) exitWith {};

// Überprüfen, ob der neue Name vom aktuellen Namen abweicht, und ggf. aktualisieren
if !(_name isEqualTo (_wantedQuery select 0)) then {
    private _query = format ["updateWantedName:%1:%2", _name, _uid];
    [_query, 2] call DB_fnc_asyncCall;
};
