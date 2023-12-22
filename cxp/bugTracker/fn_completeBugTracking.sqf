/*
	Author: Casperento
	
	Description:
	Complete bug report process

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
// Parameterdefinition für das Ergebnis des Bugreports (Standardwert: -1)
params [["_result", -1, [0]]];

// Schließt das Bugtracker-Display
(findDisplay -1) closeDisplay 1;

// Ruft die Funktion zum Speichern des Bugreports auf (aus der Konfigurationsdatei)
call compile (getText(missionConfigFile >> "Cxp_Config_BugTracker" >> "cxp_bt_saveFunction"));

// Überprüft das Ergebnis des Bugreports
if (_result isEqualTo 0) then {
    // Wenn erfolgreich, setze den Timer und zeige eine Dankesmeldung an
    cxp_bt_timer = time;
    hint (["STR_CXP_BT_Hint_Thx"] call cxp_utils_fnc_getRealText);
} else {
    // Andernfalls zeige eine Meldung an, dass der Spieler es später erneut versuchen soll
    hint (["STR_CXP_BT_Hint_tryAgainLater"] call cxp_utils_fnc_getRealText);
};
