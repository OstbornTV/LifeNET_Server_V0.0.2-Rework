#include "..\..\script_macros.hpp"
/*
    File: fn_searchVehAction.sqf
    Author:

    Description:

*/

// Das Fahrzeug, das vom Spieler untersucht wird
private _vehicle = cursorObject;

// Überprüfen, ob das Fahrzeug ein Auto ist und nicht von einem Spieler oder Schiff oder Flugzeug ist
if (_vehicle isKindOf "Car" || !(_vehicle isKindOf "Air") || !(_vehicle isKindOf "Ship")) then {
    // Die Besitzerinformationen des Fahrzeugs abrufen
    private _owners = _vehicle getVariable "vehicle_info_owners";

    // Wenn keine Besitzerinformationen vorhanden sind, beenden Sie die Aktion
    if (isNil "_owners") exitWith {
        hint localize "STR_NOTF_VehCheat";
        deleteVehicle _vehicle;
    };

    // Die Aktion als in Benutzung markieren und dem Spieler mitteilen, dass die Suche begonnen hat
    life_action_inUse = true;
    hint localize "STR_NOTF_Searching";

    // Kurze Pause für die Benutzeroberfläche
    sleep 3;

    // Die Aktion als nicht mehr in Benutzung markieren
    life_action_inUse = false;

    // Überprüfen Sie die Bedingungen für die Suche
    if (player distance _vehicle > 10 || !alive player || !alive _vehicle) exitWith {
        hint localize "STR_NOTF_SearchVehFail";
    };

    // Besitzerinformationen bearbeiten und formatieren
    _owners = [_owners] call life_fnc_vehicleOwners;

    // Wenn es keine Besitzer gibt, informieren Sie den Spieler darüber, dass es nicht im Besitz ist und zum Einlagern bereit ist
    if (_owners == "any<br/>") then {
        _owners = "No owners, impound it<br/>";
    };

    // Informieren Sie den Spieler über die Ergebnisse der Fahrzeugsuche
    hint parseText format [localize "STR_NOTF_SearchVeh", _owners];
};
