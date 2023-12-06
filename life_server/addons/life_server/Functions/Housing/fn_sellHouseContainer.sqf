/*
    File : fn_sellHouseContainer.sqf
    Author: NiiRoZz
    Description:
    Wird beim Verkauf des Hauses verwendet; Container setzt den Besitz auf 0
    und wird beim Neustart mit einer gespeicherten Prozedur bereinigt.
*/

params [
    ["_container", objNull, [objNull]]
];

// Beende mit einer Meldung, wenn der Container ungültig ist
if (isNull _container) exitWith {};

// Ermittle die Container-ID aus der Container-Variable
_containerID = _container getVariable ["container_id", -1];

private "_query";

// Überprüfe, ob die Container-ID ungültig ist
if (_containerID isEqualTo -1) then {
    // Der Container hat keine gültige Container-ID, daher wird er durch die Position und den Besitzer gelöscht
    _containerPos = getPosATL _container;
    private _ownerID = (_container getVariable "container_owner") select 0;
    _query = format ["deleteContainer:%1:%2", _ownerID, _containerPos];
} else {
    // Der Container hat eine gültige Container-ID, daher wird er durch die ID gelöscht
    _query = format ["deleteContainer1:%1", _containerID];
};

// Setze die Variablen im Container zurück
_container setVariable ["container_id", nil, true];
_container setVariable ["container_owner", nil, true];

// Lösche den Container
deleteVehicle _container;

// Führe die Datenbankabfrage asynchron aus
[_query, 1] call DB_fnc_asyncCall;

// Starte die gespeicherte Prozedur zum Löschen alter Container
["deleteOldContainers", 1] call DB_fnc_asyncCall;
