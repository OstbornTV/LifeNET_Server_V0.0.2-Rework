/*
    File: fn_houseCleanup.sqf
    Author: NiiRoZz
    Description:
    Räumt Container innerhalb des Hauses des Spielers auf.
*/
params [
    ["_uid", "", [""]]
];

// Abfrage für die Häuser des Spielers
private _query = format ["selectHousesCleanup:%1", _uid];
private _houses = [_query, 2, true] call DB_fnc_asyncCall;

{
    // Extrahiere die Position des Hauses
    private _pos = call compile format ["%1", _x select 1];

    // Finde das nächste Objekt vom Typ "House" zur Position
    private _house = nearestObject [_pos, "House"];

    // Extrahiere die Container des Hauses
    private _containers = _house getVariable ["containers", []];

    // Überprüfe, ob es Container gibt
    if !(_containers isEqualTo []) then {
        {
            // Lösche jeden Container
            deleteVehicle _x;
        } forEach _containers;

        // Setze die Container-Variable des Hauses auf null
        _house setVariable ["containers", nil, true];
    };

} forEach _houses;
