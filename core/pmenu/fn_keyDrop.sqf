/*
    Datei: fn_keyDrop.sqf
    Autor: Bryan "Tonic" Boardwine

    Beschreibung:
    Lässt einen Schlüssel zu einem Fahrzeug fallen (ausgenommen Häuser).
*/
disableSerialization;

// Suche nach dem Dialog mit der ID 2700
private _dialog = findDisplay 2700;
// Extrahieren der Liste aus dem Dialog mit der ID 2701
private _list = _dialog displayCtrl 2701;
// Extrahieren der ausgewählten Position in der Liste
private _sel = lbCurSel _list;

// Überprüfen, ob keine Daten ausgewählt wurden
if (_sel isEqualTo -1) exitWith {
    hint localize "STR_NOTF_noDataSelected"
};

// Überprüfen, ob kein Fahrzeug ausgewählt wurde
if (_list lbData _sel isEqualTo "") exitWith {
    hint localize "STR_NOTF_didNotSelectVehicle"
};


// Extrahieren des Index-Werts aus den Daten der ausgewählten Position in der Liste
private _index = parseNumber (_list lbData _sel);
// Extrahieren des Fahrzeugs aus der Fahrzeugliste anhand des Index-Werts
private _vehicle = life_vehicles param [_index, objNull, [objNull]];

// Überprüfen, ob das Fahrzeug gültig ist
if isNull _vehicle exitWith {};

// Verhindern, dass der Spieler den Schlüssel zu einem Haus fallen lässt
if (_vehicle isKindOf "House_F") exitWith {
    hint localize "STR_NOTF_cannotRemoveHouseKeys"
};

// Solve stupidness
if (objectParent player isEqualTo _vehicle && {locked _vehicle isEqualTo 2}) exitWith {
    hint localize "STR_NOTF_cannotDropKeys"
};


// Löschen des Fahrzeugs aus der Fahrzeugliste
life_vehicles = life_vehicles - [_vehicle];

// Aktualisieren der Fahrzeugbesitzer
private _owners = _vehicle getVariable ["vehicle_info_owners", []];
_owners deleteAt _index;
_vehicle setVariable ["vehicle_info_owners", _owners, true];

// Neuladen des Key-Menüs
call life_fnc_keyMenu
