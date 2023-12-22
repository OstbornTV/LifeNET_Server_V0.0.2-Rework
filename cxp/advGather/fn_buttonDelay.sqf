/*
	Author: Casperento
	
	Description:
	Sets a delay before re-enabling a button again

	This code is provided by CXP SCRIPTS on https://bytex.market/sellers/profile/K970748533
*/
params [
	["_ctrl", controlNull, [controlNull]],
	["_delay", "cancel_button_delay", [""]],
	["_text", "STR_CXP_ADG_Text_BtnCancel", [""]],
	["_textDelay", "STR_CXP_ADG_Text_BtnCancel_Delay", [""]],
	["_tooltip", "STR_CXP_ADG_ToolTip_BtnCancel", [""]],
	["_tooltipDelay", "STR_CXP_ADG_ToolTip_BtnCancel_Delay", [""]]
];

// Überprüfe, ob der übergebene Control-Parameter gültig ist
if (isNull _ctrl) exitWith {hint "Control broken passed to fn_buttonDelay..."};

disableSerialization;

// Berechne die Verzögerungszeit basierend auf der Konfiguration
private _delayTime = time + (getNumber(missionConfigFile >> "Cxp_Config_AdvGather" >> _delay));

// Deaktiviere den Button und setze den Tooltip entsprechend der Verzögerungszeit
_ctrl ctrlEnable false;
_ctrl ctrlSetTooltip format[[_tooltipDelay] call cxp_utils_fnc_getRealText, (getNumber(missionConfigFile >> "Cxp_Config_AdvGather" >> _delay))];

// Warte, bis die Verzögerungszeit abgelaufen ist oder das übergeordnete Control ungültig ist
waitUntil {
	_ctrl ctrlSetText format[[_textDelay] call cxp_utils_fnc_getRealText, [(_delayTime - time),"SS.MS"] call BIS_fnc_secondsToString];
	_ctrl ctrlCommit 0;
	round (_delayTime - time) <= 0 || isNull (ctrlParent _ctrl)
};

// Setze den Text des Controls auf den ursprünglichen Text
_ctrl ctrlSetText ([_text] call cxp_utils_fnc_getRealText);

// Aktualisiere den Tooltip basierend auf dem Status des Gathering-Prozesses
if (life_action_gathering) then {
	_ctrl ctrlSetTooltip (["STR_CXP_ADG_ToolTip_WaitStarted"] call cxp_utils_fnc_getRealText);
} else {
	_ctrl ctrlSetTooltip ([_tooltip] call cxp_utils_fnc_getRealText);
};

// Warte, bis der Gathering-Prozess abgeschlossen ist
waitUntil {!life_action_gathering};

// Aktiviere den Button wieder und handle spezielle Fälle, wenn die Benutzereingabe deaktiviert ist
_ctrl ctrlEnable true;
if (userInputDisabled) then {
	disableUserInput false;
	if (_delay != "cancel_button_delay" && {cxpadg_currZoneItMaxAmount isEqualTo 0}) then {
		_ctrl ctrlEnable false;
		_ctrl ctrlSetTooltip format[["STR_CXP_ADG_ToolTip_BtnStart_SelectedOut"] call cxp_utils_fnc_getRealText];
	};
};
