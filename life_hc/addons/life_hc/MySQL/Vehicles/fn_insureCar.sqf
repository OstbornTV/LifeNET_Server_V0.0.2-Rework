/*
    File: fn_insureCar.sqf
    Author: Guit0x "Lintox"
   
    Description:
    Insure a vehicle from the garage.
*/
private ["_vid", "_pid", "_query", "_thread", "_unit", "_insurancePrice"];
 
// Parameter erhalten
_vid = [_this, 0, -1, [0]] call BIS_fnc_param; // Fahrzeug-ID
_pid = [_this, 1, "", [""]] call BIS_fnc_param; // Spieler-ID
_unit = [_this, 2, objNull, [objNull]] call BIS_fnc_param; // Einheit (Spieler)
_insurancePrice = [_this, 3, 0, [0]] call BIS_fnc_param; // Versicherungspreis
 
// Erstellen Sie die SQL-Abfrage für die Aktualisierung der Fahrzeugversicherung in der Datenbank
_query = format ["UPDATE vehicles SET insure='1' WHERE pid='%1' AND id='%2'", _pid, _vid];
 
// Warten Sie, bis alle asynchronen Datenbankaufrufe abgeschlossen sind
waitUntil {!DB_Async_Active};

// Führen Sie die asynchrone Datenbankanfrage aus und erhalten Sie den Thread
_thread = [_query, 1] call HC_fnc_asyncCall;
