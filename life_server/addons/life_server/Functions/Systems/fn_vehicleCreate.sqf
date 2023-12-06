/*
    File: fn_vehicleCreate.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Answers the query request to create the vehicle in the database.
*/

params [
    ["_uid", "", [""]],
    ["_side", sideUnknown, [west]],
    ["_vehicle", objNull, [objNull]],
    ["_color", -1, [0]]
];

// Fehlerüberprüfungen
if (_uid isEqualTo "" || {_side isEqualTo sideUnknown} || {isNull _vehicle}) exitWith {};
if (!alive _vehicle) exitWith {};

// Sicherheitsüberprüfung, um das Einschleusen (No-Inject) zu verhindern
if !(isClass (missionConfigFile >> "LifeCfgVehicles" >> _className)) exitWith {"No-Inject Batiment hack script"};

private _className = typeOf _vehicle;
private _type = switch (true) do {
    case (_vehicle isKindOf "Car"): {"Car"};
    case (_vehicle isKindOf "Air"): {"Air"};
    case (_vehicle isKindOf "Ship"): {"Ship"};
};

_side = switch (_side) do {
    case west:{"cop"};
    case civilian: {"civ"};
    case independent: {"med"};
    default {"Error"};
};

private _plate = round(random(1000000));

// Rufe die Funktion auf, um das Fahrzeug in die Datenbank einzufügen
[_uid, _side, _type, _className, _color, _plate] call DB_fnc_insertVehicle;

// Setze die Informationen zur Datenbank im Fahrzeugvariablen
_vehicle setVariable ["dbInfo", [_uid, _plate], true];
