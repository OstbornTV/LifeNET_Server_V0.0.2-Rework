/*
	Author: Casperento

	Description:
	Shows a message on the player's screen when he enters on a safezone

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_mode",0,[0]],
	["_cfgName","",[""]]
];

// Holt die Konfigurationswerte für die Safezone
private _msgIn = getArray(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "in_message");
private _msgOut = getArray(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "out_message");
private _canKnockout = getText(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "can_knockout");
private _canShoot = getText(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "can_shoot");
private _canDie = getText(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "can_die");
private _canLockPick = getText(missionConfigFile >> "Cxp_Config_Safezones" >> "Cxp_Safezones" >> _cfgName >> "can_lockpick");

// Überprüft, ob boolsche Werte als Strings angegeben wurden
if (!(_canKnockout isEqualType "") || !(_canShoot isEqualType "") || !(_canDie isEqualType "") || !(_canLockPick isEqualType "")) exitWith {diag_log "[CXP-SAFEZONES-ERROR] It seems that you typed a bool value inside cxp_szs_tggs. Please change it to a string like: true >> ""true"""};

// Überprüft den Modus (0 für Betreten, 1 für Verlassen)
if (_mode isEqualTo 0) exitWith {
	// Zeigt die Betreten-Nachricht an
	hint parseText format["<t color=""%1"" size=""2.0"" shadow=""1"" align=""center"">%2</t><br/><br/>%3",_msgIn select 2,_msgIn select 0,_msgIn select 1];
	cxpsfz_currentSfz = _cfgName;

	// Deaktiviert Aktionen basierend auf der Safezone-Konfiguration
	if (_canShoot isEqualTo "false") then {cxpsfz_stopShooting = true;};
	if (_canDie isEqualTo "false") then {player allowDamage false};
	if (_canKnockout isEqualTo "false") then {life_knockout = true;};
	if (_canLockPick isEqualTo "false") then {
		if !(isNil "life_canLockPick") then {
			life_canLockPick = false;
		} else {
			diag_log "[CXP-SAFEZONES-ERROR] It seems that you haven""t defined the life_canLockPick variable in your fn_lockpick.sqf...If you don""t do that, you won""t be able to use the can_lockpick config option !!!";
		};
	};
};

// Überprüft den Modus (0 für Betreten, 1 für Verlassen)
if (_mode isEqualTo 1) exitWith {
	// Zeigt die Verlassen-Nachricht an
	hint parseText format["<t color=""%1"" size=""2.0"" shadow=""1"" align=""center"">%2</t><br/><br/>%3",_msgOut select 2,_msgOut select 0,_msgOut select 1];
	cxpsfz_currentSfz = "";

	// Aktiviert Aktionen basierend auf der Safezone-Konfiguration
	if (_canShoot isEqualTo "false") then {cxpsfz_stopShooting = false;};
	if (_canDie isEqualTo "false") then {player allowDamage true};
	if (_canKnockout isEqualTo "false") then {life_knockout = false;};
	if (_canLockPick isEqualTo "false") then {
		life_canLockPick = true;
	};
};
