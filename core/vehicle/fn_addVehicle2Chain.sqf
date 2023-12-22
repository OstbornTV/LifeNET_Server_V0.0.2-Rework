/*
    File: fn_addVehicle2Chain.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    A short function for telling the player to add a vehicle to his keychain.
*/

private "_vehicle";

// Das übergebene Fahrzeug als Parameter annehmen, Standardwert ist objNull
_vehicle = param [0, objNull, [objNull]];

// Überprüfen, ob das Fahrzeug noch nicht in der Liste der Spielerfahrzeuge ist
if (!(_vehicle in life_vehicles)) then {
    // Wenn nicht, das Fahrzeug zur Liste hinzufügen
    life_vehicles pushBack _vehicle;
};
