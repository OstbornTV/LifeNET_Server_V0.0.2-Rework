/*
	Author: Casperento
	
	Description:
	Starts bug reporting process

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Parameter: "_ctrl" - Das Steuerelement, das den Aufruf ausgelöst hat
params ["_ctrl"];

// Extrahiert das übergeordnete Display des Steuerelements
private _display = ctrlParent _ctrl;

// Deaktiviert die Serialisierung, um Probleme mit der Textverarbeitung zu vermeiden
disableSerialization;

// Extrahiert den Text aus den beiden Eingabefeldern
private _bugTxt = ctrlText (_display displayCtrl 7302);
private _behavTxt = ctrlText (_display displayCtrl 7301);

// Überprüft, ob die Eingabefelder leer sind, und beendet den Prozess, wenn dies der Fall ist
if ((_bugTxt isEqualTo "") || (_behavTxt isEqualTo "")) exitWith {
	closeDialog 0; // Schließt das aktuelle Dialogfeld
	hint (["STR_CXP_BT_Hint_emptyStr"] call cxp_utils_fnc_getRealText); // Gibt eine Benachrichtigung aus
};

// Extrahiert konfigurierte Erlaubte Zeichen und Maximalanzahl von Zeichen
private _allowedChar = toArray(getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_allowedChar"));
private _allowedLen = getNumber(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_lenChar");

// Überprüft, ob die Anzahl der Zeichen in den Eingabefeldern die maximal zulässige Anzahl überschreitet
if (count(toArray(_bugTxt)) > _allowedLen || count(toArray(_behavTxt)) > _allowedLen) exitWith {
	hint format [(["STR_CXP_BT_Hint_CharLen"] call cxp_utils_fnc_getRealText), _allowedLen]; // Gibt eine Benachrichtigung aus
};

// Überprüft, ob nicht erlaubte Zeichen in den Eingabefeldern enthalten sind
private _badCharBug = (toArray(_bugTxt)) findIf {!(_x in _allowedChar)} isEqualTo -1;
private _badCharBhv = (toArray(_behavTxt)) findIf {!(_x in _allowedChar)} isEqualTo -1;

// Beendet den Prozess, wenn nicht erlaubte Zeichen gefunden werden
if !(_badCharBug && _badCharBhv) exitWith {
	hint (["STR_CXP_BT_Hint_UnsuppChar"] call cxp_utils_fnc_getRealText); // Gibt eine Benachrichtigung aus
};

// Extrahiert den Spieler-Namen und bereitet die gemeldeten Texte vor
private _playerName = profileName call cxp_utils_fnc_mresString;
_bugTxt = _bugTxt call cxp_utils_fnc_mresString;
_behavTxt = _behavTxt call cxp_utils_fnc_mresString;

// Ruft die Funktion zur Speicherung des Bug-Reports im Remote-Exekutionsmodus auf
[getPlayerUID player, _playerName, _bugTxt, _behavTxt, player] remoteExecCall ["cxpbt_fnc_saveBugReported",2];
