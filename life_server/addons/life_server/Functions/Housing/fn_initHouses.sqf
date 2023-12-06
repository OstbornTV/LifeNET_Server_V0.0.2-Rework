/*
    File: fn_initHouses.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Initialisiert die Einrichtung von Häusern, wenn ein Spieler dem Server beitritt.
*/

// Ermittle die Anzahl der Häuser in der Datenbank
private _count = (["selectAllHouses", 2] call DB_fnc_asyncCall) select 0;

// Iteriere durch die Häuser in 10er Schritten
for [{_x = 0},{_x <= _count},{_x=_x+10}] do {
    // Erstelle die Datenbankabfrage für die Häuser des Spielers
    private _query = format ["selectPlayerHouses:%1", _x];
    // Führe die Datenbankabfrage asynchron aus
    private _queryResult = [_query, 2, true] call DB_fnc_asyncCall;
    
    // Beende die Schleife, falls kein Ergebnis vorhanden ist
    if (_queryResult isEqualTo []) exitWith {};
    
    // Iteriere durch jedes Haus im Ergebnis
    {
        // Extrahiere die Position des Hauses aus dem Ergebnis
        _pos = call compile format ["%1", _x select 2];
        // Finde das nächstgelegene Objekt (Haus) an dieser Position
        _house = nearestObject [_pos, "House"];
        // Setze die Variable "house_owner" im Haus
        _house setVariable ["house_owner",[_x select 1, _x select 3],true];
        // Setze die Variable "house_id" im Haus
        _house setVariable ["house_id", _x select 0, true];
        // Setze die Variable "locked" im Haus (Alles verschließen)
        _house setVariable ["locked", true, true];
        // Falls das Haus eine Garage hat (Garage gekauft), setze "garageBought" im Haus
        if (_x select 4 isEqualTo 1) then {
            _house setVariable ["garageBought", true, true];
        };
        // Ermittle die Anzahl der Türen im Haus
        _numOfDoors = getNumber(configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");
        // Deaktiviere alle Türen im Haus
        for "_i" from 1 to _numOfDoors do {
            _house setVariable [format ["bis_disabled_Door_%1",_i], 1, true];
        };
    } forEach _queryResult;
};

// Ermittle die Namen der für Garagen gesperrten Häuser und Garagen
private _blacklistedHouses = "count (getArray (_x >> 'garageBlacklists')) > 0" configClasses (missionconfigFile >> "Housing" >> worldName);
private _blacklistedGarages = "count (getArray (_x >> 'garageBlacklists')) > 0" configClasses (missionconfigFile >> "Garages" >> worldName);
_blacklistedHouses = _blacklistedHouses apply {configName _x};
_blacklistedGarages = _blacklistedGarages apply {configName _x};

// Iteriere durch die für Garagen gesperrten Häuser und markiere diese als "blacklistedGarage"
for "_i" from 0 to count(_blacklistedHouses)-1 do {
    _className = _blacklistedHouses select _i;
    _positions = getArray(missionConfigFile >> "Housing" >> worldName >> _className >> "garageBlacklists");
    {
        _obj = nearestObject [_x, _className];
        if (isNull _obj) then {
            _obj setVariable ["blacklistedGarage", true, true];
        };
    } forEach _positions;
};

// Iteriere durch die für Garagen gesperrten Garagen und markiere diese als "blacklistedGarage"
for "_i" from 0 to count(_blacklistedGarages)-1 do {
    _className = _blacklistedGarages select _i;
    _positions = getArray(missionConfigFile >> "Garages" >> worldName >> _className >> "garageBlacklists");
    {
        _obj = nearestObject [_x, _className];
        if (isNull _obj) then {
            _obj setVariable ["blacklistedGarage", true, true];
        };
    } forEach _positions;
};
