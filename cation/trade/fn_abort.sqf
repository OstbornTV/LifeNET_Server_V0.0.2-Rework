/*
    File: fn_abort.sqf
    Author: Julian Bauer (julian.bauer@cationstudio.com)

    Description:
	Handles exceptions
*/
params[
	["_playerObject",objNull,[objNull]],
	["_case",-1,[0]]
];
switch (_case) do {
	case 0: {
        [player,1] remoteExecCall ["cat_trade_fnc_abort",_playerObject];
        cat_trade_aborted = true;
        hint format [["aborted"] call cat_trade_fnc_getText];
        (findDisplay 46) displayRemoveEventHandler ["KeyDown",cat_trade_esc_eventhandler];
		cat_trade_receiver = objNull;
	};
	case 1: {
		disableSerialization;
		closeDialog 0;
		cat_trade_aborted = false;
		hint format[["abortedVendor"] call cat_trade_fnc_getText,name _playerObject];
	};
	case 2: {
		disableSerialization;
		[] spawn {sleep 2; hint format[["aborted"] call cat_trade_fnc_getText];};
		cat_trade_vendor = objNull;
		cat_trade_aborted = false;
		[player,3] remoteExecCall ["cat_trade_fnc_abort",_playerObject];
		closeDialog 0;
	};
	case 3: {
		hint format[["abortedBuyer"] call cat_trade_fnc_getText,name _playerObject];
        cat_trade_aborted = true;
        (findDisplay 46) displayRemoveEventHandler ["KeyDown",cat_trade_esc_eventhandler];
		cat_trade_receiver = objNull;
	};
};