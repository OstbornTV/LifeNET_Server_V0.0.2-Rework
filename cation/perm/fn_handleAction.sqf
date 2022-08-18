/*
    File: fn_handleAction.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Submits changes to receiver
*/

params [
	["_action",-1,[0]]
];

private _display = findDisplay 9500;
private _receiver = _display getVariable ["receiver",objNull];
if (isNull _receiver || _action isEqualTo -1) exitWith {};

switch (_action) do {
	case 0: { 
		private _cash = parseNumber(ctrlText 9516);
		if (_cash > 999999) exitWith {hint ["moneyFail"] call cat_perm_fnc_getText;};
		private _exit = false;
		if (getNumber(missionConfigFile >> "Cation_Perm" >> "ownmoney") isEqualTo 1) then {
			if (_cash > life_cash) exitWith {_exit = true;};
			life_cash = life_cash - _cash;
			[0] call SOCK_fnc_updatePartial;
		};
		if (_exit) exitWith {hint ["notEnoughMoney"] call cat_fnc_getText;};
		[0,str(_cash),name player] remoteExecCall ["cat_perm_fnc_updatePlayer",_receiver];
		hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderMoney"] call cat_perm_fnc_getText,name _receiver,_cash,["currency"] call cat_perm_fnc_getText],format[["changes"] call cat_perm_fnc_getText]];
	};
	case 1: { 
		private _licence = lbData[9513,(lbCurSel 9513)];
		[1,_licence,name player] remoteExecCall ["cat_perm_fnc_updatePlayer",_receiver];
		hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderLicAdd"] call cat_perm_fnc_getText,localize getText(missionConfigFile >> "Licenses" >> _licence >> "displayName"),name _receiver],format[["changes"] call cat_perm_fnc_getText]];
	};
	case 2: { 
		private _licence = lbData[9519,(lbCurSel 9519)];
		[2,_licence,name player] remoteExecCall ["cat_perm_fnc_updatePlayer",_receiver];
		hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderLicWithdraw"] call cat_perm_fnc_getText,localize getText(missionConfigFile >> "Licenses" >> _licence >> "displayName"),name _receiver],format[["changes"] call cat_perm_fnc_getText]];
	};
	case 3: { 
		private _rank = parseNumber(lbData[9510,(lbCurSel 9510)]);
		private _oldRank = _display getVariable ["rank",0];		
		_licenseSide = switch (playerSide) do {case west:{"cop"}; case civilian:{"civ"}; case independent:{"med"};};
		[3,str(_rank),name player,playerSide,_oldRank,_licenseSide] remoteExecCall ["cat_perm_fnc_updatePlayer",_receiver];
		if (_rank > 0) then {
			if (_rank < _oldRank) then {
				hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderDeg"] call cat_perm_fnc_getText,_rank,name _receiver],format[["changes"] call cat_perm_fnc_getText]];
			} else {
				hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderPro"] call cat_perm_fnc_getText,_rank,name _receiver],format[["changes"] call cat_perm_fnc_getText]];
			};
		} else {
			hint parseText format ["<t>%1</t><br/><br/><t>%2</t>",format[["messageSenderFired"] call cat_perm_fnc_getText,name _receiver],format[["changes"] call cat_perm_fnc_getText]];
		};
	};
};

[_receiver] spawn cat_perm_fnc_refreshPermDialog;