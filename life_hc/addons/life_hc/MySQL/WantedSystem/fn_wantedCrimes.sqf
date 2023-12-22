#include "\life_hc\hc_macros.hpp"

/*
    File: fn_wantedCrimes.sqf
    Author: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    This file is for Nanou's HeadlessClient.

    Description:
    Grabs a list of crimes committed by a person.
*/

disableSerialization;  // Deaktiviert die Serialisierung für dieses Skript

params [
    ["_ret", objNull, [objNull]],  // Rückgabeobjekt, an das die Verbrechen übergeben werden
    ["_criminal", [], [[]]]  // Array mit Informationen über die Person und ihre Verbrechen
];

// Erstellen der Datenbankabfrage, um aktive Verbrechen für die Person abzurufen
private _query = format ["selectWantedActive:%1", _criminal select 0];
private _queryResult = [_query, 2] call HC_fnc_asyncCall;  // Asynchrone Datenbankanfrage

private _type = _queryResult select 0;

// Wenn der Datentyp des Ergebnisses nicht korrekt ist, in einen lesbaren String umwandeln
if (_type isEqualType "") then {
    _type = call compile format ["%1", _type];
};

private _crimesArr = [];

// Iteriere durch die Verbrechenstypen und erstelle einen lesbaren String für jedes Verbrechen
{
    private _str = format ["STR_Crime_%1", _x];
    _crimesArr pushBack _str;
    false
} count _type;

// Aktualisiere das Ergebnis der Datenbankabfrage mit den lesbaren Verbrechenstypen
_queryResult set [0, _crimesArr];

// Übermittle die Informationen an die Funktion life_fnc_wantedInfo auf dem Server
[_queryResult] remoteExec ["life_fnc_wantedInfo", _ret];
