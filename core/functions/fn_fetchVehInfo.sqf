/*
    File: fn_fetchVehInfo.sqf
    Author: Bryan "Tonic" Boardwine
    Edit: OsbornTV

    Description:
    Wird verwendet, um Informationen über ein Fahrzeug aus Config >> "CfgVehicles" zurückzugeben.

    Return:
    0: Klassenname
    1: Scope
    2: Bild
    3: Anzeigename
    4: Fahrzeugklasse
    5: Seite
    6: Fraktion
    7: Basis / Superklasse
    8: Max. Geschwindigkeit
    9: Panzerungsbewertung
    10: Passagiersitze
    11: Max. Pferdestärken
    12: Kraftstoffkapazität
*/
params [
    ["_class", "", [""]]
];

if (_class isEqualTo "") exitWith {[]}; // Ungültige Klasse übergeben.
private _config = configFile >> "CfgVehicles" >> _class;
if (!isClass _config) exitWith {[]}; // Klasse existiert nicht in CfgVehicles

private _scope = getNumber(_config >> "scope");
private _picture = getText(_config >> "picture");
private _displayName = getText(_config >> "displayName");
private _vehicleClass = getText(_config >> "vehicleClass");
private _side = getNumber(_config >> "side");
private _faction = getText(_config >> "faction");
private _superClass = inheritsFrom _config;
private _speed = getNumber(_config >> "maxSpeed");
private _armor = getNumber(_config >> "armor");
// Anzahl der Sitze = Anzahl der Passagiere + Anzahl der Fahrzeugtürme
private _seats = getNumber(_config >> "transportSoldier") + count("true" configClasses (_config >> "Turrets"));
private _hp = getNumber(_config >> "enginePower");
private _fuel = getNumber(_config >> "fuelCapacity");

[_class, _scope, _picture, _displayName, _vehicleClass, _side, _faction, _superClass, _speed, _armor, _seats, _hp, _fuel];
