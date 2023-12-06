#include "\life_server\script_macros.hpp"

/*
	Author: Casperento
	
	Beschreibung:
	Speichert einen gemeldeten Fehler in der Datenbank

	Dieser Code wird von CXP SCRIPTS auf https://bytex.market/sellers/profile/K970748533 zur Verfügung gestellt
*/
params [
	["_rptrUID","",[""]],    // UID des Meldenden (Reporter)
	["_rptrName","",[""]],   // Name des Meldenden
	["_bugRptr","",[""]],    // Gemeldeter Fehler
	["_exptdBeha","",[""]],  // Erwartetes Verhalten
	["_unit",objNull,[objNull]]  // Einheitenobjekt (optional)
];

// Überprüfen, ob alle erforderlichen Parameter vorhanden sind
if ((_rptrUID isEqualTo "") || (_rptrName isEqualTo "") || (_bugRptr isEqualTo "") || (_exptdBeha isEqualTo "")) exitWith {
	// Wenn nicht, das Skript beenden
	[] remoteExecCall ["cxpbt_fnc_completeBugTracking",owner _unit];
};

// SQL-Abfrage für das Einfügen der Daten in die BugTracker-Tabelle
private _query = format["INSERT INTO bugTracker SET pid ='%1', name = '%2', bugReported = '%3', expectedBhv = '%4'",_rptrUID,_rptrName,_bugRptr,_exptdBeha];

// Async-Funktion aufrufen, um die Datenbankabfrage durchzuführen
call compile (getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_asyncFuntion"));

// Skript für das Abschließen der Fehlerverfolgung aufrufen
[0] remoteExecCall ["cxpbt_fnc_completeBugTracking",owner _unit];
