/*
This script initializes the system. Call this file with the path of the script directory to start it.
Argument:
	_this: STRING - A string containing the relative path to the "sperrzonensystem" directory from mission root, for example "scripts\thirdparty\sperrzonensystem\"
*/

diag_log "Sperrzonensystem wird geladen.";
diag_log "Entwickler: http://steamcommunity.com/profiles/76561198074709001";

if(isNil "_this") exitWith {
	diag_log "Sperrzonensystem konnte nicht geladen werden, da kein Pfad zum 'sperrzonensystem'-Verzeichnis an 'sperrzonensystem\main.sqf' übergeben wurde.";
};
if (typeName _this == "ARRAY") then {
	_this = _this select 0;
};
if (typeName _this != "STRING") exitWith {
	diag_log "Sperrzonensystem konnte nicht geladen werden, da das Argument, dass an 'sperrzonensystem\main.sqf' übergeben wurde, kein String ist."
};
stig_sz_root = _this;
if (!(((toArray stig_sz_root)select(count toArray stig_sz_root) - 1) == ((toArray "\")select 0))) then {
	//if stig_sz_root does not end with \ but needs one to be a directory path... add a "\"
	stig_sz_root = stig_sz_root + "\";
};
diag_log "Sperrzonensystem: Einstellungen werden geladen.";
call compile preprocessFileLineNumbers (stig_sz_root + "settings.sqf");
diag_log "Sperrzonensystem: Funktionen werden geladen.";
call compile preprocessFileLineNumbers (stig_sz_root + "scripts\loadFunctions.sqf");
if(!(call compile format["stig_sz_enable_%1",str side player]))exitWith {
	diag_log ("Sperrzonensystem: GUI wird nicht aktiviert, da es in den Einstellungen für die Fraktion " + (str side player) + " deaktiviert wurde.");
};
private _condition = call compile format["stig_sz_condition_%1",str side player];
if(!(call _condition))exitWith {
	diag_log "Sperrzonensystem: GUI wird nicht aktiviert, da die Sonderbedingung nicht erfüllt wurde.";
};
diag_log "Sperrzonensystem: GUI wird geladen.";
waitUntil {!isNull (findDisplay 12)};
call compile preprocessFileLineNumbers (stig_sz_root + "scripts\createGUI.sqf");