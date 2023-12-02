#include "..\..\script_macros.hpp"
/*
    File: fn_placeContainer.sqf
    Author: NiiRoZz
    Credits: BoGuu

    Description:
    Check container if it's in a house owned by the player, and if all these conditions are true, add the container to the database.
*/

// Übergebene Parameter: _container (Containerobjekt), _isFloating (Flag für schwebende Container, standardmäßig true)
private ["_container", "_isFloating", "_type", "_house", "_containers", "_houseCfg", "_message", "_isPlaced"];
params [
    ["_container", objNull, [objNull]],
    ["_isFloating", true, [true]]
];

// Spieler UID abrufen
_uid = getPlayerUID player;

// Das nächstgelegene Hausobjekt abrufen
_house = nearestObject [player, "House"];

// Container-Typ basierend auf dem Objekttyp des Containers festlegen
switch (true) do {
    case (typeOf _container isEqualTo "B_supplyCrate_F"): {_type = "storagebig";};
    case (typeOf _container isEqualTo "Box_IND_Grenades_F"): {_type = "storagesmall";};
    default {_type = "";};
};

// Meldungsvariable initialisieren
_message = 0;

// Flag für platzierten Container initialisieren
_isPlaced = false;

// Überprüfen, ob das Hausobjekt nicht null ist
if (!isNull _house) then {
    _message = 1; // Meldung 1: Ein Haus wurde in der Nähe gefunden
    // Überprüfen, ob der Spieler im Haus ist und der Container sich im Haus befindet
    if (([player] call life_fnc_playerInBuilding) && {([_container] call life_fnc_playerInBuilding)}) then {
        _message = 2; // Meldung 2: Der Spieler und der Container befinden sich beide im Haus
        // Überprüfen, ob das Haus ein Fahrzeug ist und einen Eigentümer hat
        if ((_house in life_vehicles) && !(isNil {_house getVariable "house_owner"})) then {
            _message = 3; // Meldung 3: Das Haus ist ein Fahrzeug mit einem Eigentümer
            // Überprüfen, ob der Container nicht schwebend ist
            if (!_isFloating) then {
                _message = 4; // Meldung 4: Der Container ist nicht schwebend
                // Containerinformationen aus dem Haus abrufen
                _containers = _house getVariable ["containers", []];
                // Konfiguration des Hausobjekts abrufen
                _houseCfg = [(typeOf _house)] call life_fnc_houseConfig;
                // Wenn die Hauskonfiguration ungültig ist, die Ausführung beenden
                if (_houseCfg isEqualTo []) exitWith {};
                // Überprüfen, ob die Anzahl der Container im Haus die maximale Anzahl überschreitet
                if (count _containers < (_houseCfg select 1)) then {
                    _isPlaced = true; // Container erfolgreich platziert
                    // Container zum Headless Client oder zum Server hinzufügen
                    if (life_HC_isActive) then {
                        [_uid, _container] remoteExec ["HC_fnc_addContainer", HC_Life];
                    } else {
                        [_uid, _container] remoteExec ["TON_fnc_addContainer", RSERV];
                    };
                    // Containervariablen setzen
                    _container setVariable ["Trunk", [[], 0], true];
                    _container setVariable ["container_owner", [_uid], true];
                    // Container zur Liste der Hauscontainer hinzufügen
                    _containers pushBack _container;
                    _house setVariable ["containers", _containers, true];
                    sleep 1; // Kurze Pause
                };
            };
        };
    };
};

// Falls der Container erfolgreich platziert wurde, die Ausführung beenden
if (_isPlaced) exitWith {};

// Container löschen, da er nicht platziert wurde
deleteVehicle _container;

// Inventory-Handling-Funktion aufrufen
[true, _type, 1] call life_fnc_handleInv;

// Meldungen basierend auf der Meldungsvariable anzeigen
switch (_message) do {
    case 0: {hint localize "STR_House_Container_House_Near";};
    case 1: {hint localize "STR_House_Container_House_Near";};
    case 2: {hint localize "STR_House_Container_House_Near_Owner";};
    case 3: {hint localize "STR_House_Container_Floating";};
    case 4: {hint localize "STR_ISTR_Box_HouseFull";};
};
