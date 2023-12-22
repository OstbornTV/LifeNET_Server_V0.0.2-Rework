#include "\life_hc\hc_macros.hpp"

/*
    File: fn_wantedAdd.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Adds or appends a unit to the wanted list.
*/

params [
    ["_uid","",[""]],             // UID der gesuchten Einheit
    ["_name","",[""]],            // Name der gesuchten Einheit
    ["_type","",[""]],            // Art der Straftat
    ["_customBounty",-1,[0]]      // Benutzerdefinierte Belohnung für die Straftat (Standardwert: -1)
];

if (_uid isEqualTo "" || {_type isEqualTo ""} || {_name isEqualTo ""}) exitWith {};  // Beende das Skript bei ungültigen Parametern

// Welche Straftat liegt vor?
private _crimesConfig = getArray(missionConfigFile >> "Life_Settings" >> "crimes");
private _index = [_type, _crimesConfig] call life_util_fnc_index;

if (_index isEqualTo -1) exitWith {};  // Beende das Skript, wenn der Straftatentyp nicht gefunden wird

_type = [_type, parseNumber ((_crimesConfig select _index) select 1)];

if (_type isEqualTo []) exitWith {};  // Beende das Skript, wenn der Straftatentyp ungültig ist

// Wird eine benutzerdefinierte Belohnung übergeben? Setze sie als Preis.
if !(_customBounty isEqualTo -1) then {_type set[1,_customBounty];};

// Überprüfe die Wanted-Liste, um sicherzustellen, dass die Einheit nicht bereits darauf steht.
private _query = format ["selectWantedID:%1", _uid];
private _queryResult = [_query,2,true] call HC_fnc_asyncCall;
private _val = _type select 1;
private _number = _type select 0;

if !(_queryResult isEqualTo []) then {
    // Eintrag existiert bereits, aktualisiere die bestehenden Straftaten
    _query = format ["selectWantedCrimes:%1", _uid];
    _queryResult = [_query,2] call HC_fnc_asyncCall;
    _pastCrimes = _queryResult select 0;

    if (_pastCrimes isEqualType "") then {_pastCrimes = call compile format ["%1", _pastCrimes];};
    _pastCrimes pushBack _number;
    _query = format ["updateWanted:%1:%2:%3", _pastCrimes, _val, _uid];
    [_query,1] call HC_fnc_asyncCall;
} else {
    // Eintrag existiert nicht, füge einen neuen Eintrag hinzu
    _crime = [_type select 0];
    _query = format ["insertWanted:%1:%2:%3:%4", _uid, _name, _crime, _val];
    [_query,1] call HC_fnc_asyncCall;
};
