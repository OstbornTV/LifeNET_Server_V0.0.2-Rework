/*
  Dieses Skript initialisiert das System. Rufen Sie diese Datei mit dem Pfad des Skriptverzeichnisses auf, um es zu starten.
  Argument:
   _this: STRING - Ein String mit dem relativen Pfad zum Verzeichnis "sperrzonensystem" vom Missions-Stammverzeichnis aus, z. B. "scripts\thirdparty\sperrzonensystem\"
*/

// Informationsprotokollierung über den Start des Sperrzonensystems und Entwicklerdetails
diag_log "Sperrzonensystem wird geladen.";
diag_log "Entwickler: http://steamcommunity.com/profiles/76561198074709001";

// Überprüfen, ob das Argument _this vorhanden ist
if (isNil "_this") exitWith {
  diag_log "Sperrzonensystem konnte nicht geladen werden, da kein Pfad zum 'sperrzonensystem'-Verzeichnis an 'sperrzonensystem\\main.sqf' übergeben wurde.";
};

// Falls das Argument ein Array ist, wird der erste Eintrag ausgewählt
if (typeName _this == "ARRAY") then {
  _this = _this select 0;
};

// Überprüfen, ob _this ein String ist, andernfalls wird das Skript beendet
if (typeName _this != "STRING") exitWith {
  diag_log "Sperrzonensystem konnte nicht geladen werden, da das Argument, das an 'sperrzonensystem\main.sqf' übergeben wurde, kein String ist."
};

// Festlegen des Stammverzeichnisses für das Sperrzonensystem
stig_sz_root = _this;

// Überprüfen und Hinzufügen eines Schrägstrichs am Ende des Verzeichnispfads
if (!(((toArray stig_sz_root) select (count toArray stig_sz_root) - 1) == ((toArray "\") select 0))) then {
  stig_sz_root = stig_sz_root + "\";
};

// Protokollierung des Ladens der Einstellungen
diag_log "Sperrzonensystem: Einstellungen werden geladen.";
call compile preprocessFileLineNumbers (stig_sz_root + "settings.sqf");

// Protokollierung des Ladens der Funktionen
diag_log "Sperrzonensystem: Funktionen werden geladen.";
call compile preprocessFileLineNumbers (stig_sz_root + "scripts\loadFunctions.sqf");

// Überprüfen, ob die GUI für die Fraktion aktiviert ist
if (!(call compile format["stig_sz_enable_%1", str side player])) exitWith {
  diag_log ("Sperrzonensystem: GUI wird nicht aktiviert, da es in den Einstellungen für die Fraktion " + (str side player) + " deaktiviert wurde.");
};

// Überprüfen der Sonderbedingung für die GUI-Aktivierung
private _condition = call compile format["stig_sz_condition_%1", str side player];
if (!(call _condition)) exitWith {
  diag_log "Sperrzonensystem: GUI wird nicht aktiviert, da die Sonderbedingung nicht erfüllt wurde.";
};

// Protokollierung des Ladens der GUI
diag_log "Sperrzonensystem: GUI wird geladen.";

// Warten, bis das Display mit der ID 12 nicht mehr null ist, und dann die GUI laden
waitUntil {!isNull (findDisplay 12)};
call compile preprocessFileLineNumbers (stig_sz_root + "scripts\createGUI.sqf");