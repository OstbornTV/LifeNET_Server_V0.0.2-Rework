/*
    File : fn_deleteDBContainer.sqf
    Author: NiiRoZz

    Description:
    Löscht den Container und entfernt ihn aus der Datenbank
*/

params [
    ["_container", objNull, [objNull]]
];

// Überprüfen, ob der Container ungültig ist
if (isNull _container) exitWith {diag_log "Container ist null";};

// Holen Sie die Container-ID aus den Variablen des Containers
_containerID = _container getVariable ["container_id", -1];

private "_query";

// Überprüfen, ob die Container-ID ungültig ist
if (_containerID isEqualTo -1) then {
    // Holen Sie die Position und die Besitzer-ID des Containers
    _containerPos = getPosATL _container;
    private _ownerID = (_container getVariable "container_owner") select 0;

    // Erstellen Sie die Löschabfrage für den nicht indizierten Container
    _query = format ["deleteContainer:%1:%2", _ownerID, _containerPos];
} else {
    // Erstellen Sie die Löschabfrage für den indizierten Container
    _query = format ["deleteContainer1:%1", _containerID];
};

// Setzen Sie die Container-Variablen auf null
_container setVariable ["container_id", nil, true];
_container setVariable ["container_owner", nil, true];

// Führen Sie die asynchrone Datenbankaktualisierung durch
[_query, 1] call DB_fnc_asyncCall;

// Führen Sie eine asynchrone Datenbankaktualisierung durch, um alte Container zu löschen
["deleteOldContainers", 1] call DB_fnc_asyncCall;

// Löschen Sie das Fahrzeug (Container)
deleteVehicle _container;
